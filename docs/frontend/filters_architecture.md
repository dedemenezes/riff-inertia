# Filter Architecture

This document maps how filter UIs work in the Inertia/Vue frontend. Update it
whenever the structure, data contract, navigation behavior, or shared filter
components change.

## Purpose

Filters are a central discovery mechanism for the festival site. They appear on
film listings, programming pages, showcase pages, previous-edition pages, and
news listings. A small UI change can affect URL state, Inertia partial reloads,
infinite scroll, mobile drawers, and server-provided filter options.

## Core Principles

- Rails owns filter data. Controllers send filter options and
  `current_filters` as Inertia props.
- Vue owns temporary form state while the user is editing filters.
- URL params are the shareable source of applied filters.
- Applying or removing filters navigates through Inertia, usually with
  `router.get`.
- Components render server-provided data; they should not fetch filter options
  client-side.
- Mobile filters are shown in a fullscreen drawer with scrollable content and
  sticky actions.
- Desktop filters are shown inline or in a sticky side area, depending on the
  page.

## Filter Data Contract

Applied filters are represented as objects with this shape:

```js
{
  filter_display: "Premiere Brasil",
  filter_value: "premiere-brasil",
  filter_label: "Mostra",
}
```

The exact keys in `current_filters` vary by page, but common keys include:

- `query`
- `sessao`
- `mostra`
- `cinema`
- `genero`
- `pais`
- `direcao`
- `elenco`
- `caderno`
- `data`

When applying filters, frontend helpers extract `filter_value` into URL params.
When rendering selected filter tags, the UI displays `filter_display`. Labels
come from `filter_label` or from controller-provided option labels.

## Main Components

### Layout and Shell

- `app/frontend/components/features/filters/ResponsiveFilterMenu.vue`
  - Shared responsive shell for most filter surfaces.
  - Desktop: visible sticky/sidebar-style filter area.
  - Mobile: fullscreen drawer rendered through `Teleport`.
  - Delegates filter logic to `SearchFilter`.

- `app/frontend/components/features/filters/SearchFilter.vue`
  - Owns generic filter actions: update field, apply filters, clear filters,
    detect active filters.
  - Exposes slot props to page-specific filter forms:
    - `modelValue`
    - `updateField`
    - `clearField`
    - `hasActiveFilters`
  - Renders sticky `FilterActions` by default.

- `app/frontend/components/features/filters/FilterActions.vue`
  - Shared apply/clear action area.
  - Must remain reachable in mobile drawers when filter content scrolls.

- `app/frontend/components/features/filters/MobileTrigger.vue`
  - Opens the mobile filter drawer.

- `app/frontend/components/features/filters/composables/useMobileTrigger.js`
  - Controls mobile drawer open/close state.
  - Locks body scroll while the drawer is open.

### Page-Specific Forms

- `app/frontend/components/features/filters/ProgramsFilterForm.vue`
  - Used by programming/session listings.
  - Handles fields such as search, session time, showcase, cinema, genre,
    country, director, and cast.

- `app/frontend/components/features/filters/MostrasFilterForm.vue`
  - Used by showcase film listings and previous-edition film listings.
  - Handles fields such as search, sub-showcase, genre, country, director, and
    cast.

- `app/frontend/components/features/mostras/MostraShowContent.vue`
  - Shared renderer for showcase film listings (title, sub-showcase badges,
    carousel, filters, infinite-scroll grid).
  - Uses `ResponsiveFilterMenu` with `MostrasFilterForm` and `useSearchFilter`.
  - Consumed by both the current-edition and previous-edition showcase show pages.

- `app/frontend/components/features/filters/NoticiasFilterForm.vue`
  - Used by news listings.
  - Handles publication date, subject/category (`caderno`), and keyword search
    filters.

### Field Controls

- `app/frontend/components/features/filters/SearchBar.vue`
  - Text search field used by filter forms or page toolbars.

- `app/frontend/components/ui/ComboboxComponent.vue`
  - Used for option-based filters.

- `app/frontend/components/ui/SelectComponent.vue`
  - Used where a select-style control is appropriate.

- `app/frontend/components/ui/DatePickerComponent.vue`
  - Used for date filters.

Filter field controls share the Figma input contract through
`app/frontend/components/ui/inputStyles.js`: 45px height, 12px horizontal and
vertical padding, `radius-100` (4px), `neutrals-300` border, white background,
and Inter 14px/150% text. Text search, date picker, combobox, select trigger,
and the base UI input should all use this contract so filter fields keep the
same visual appearance across desktop and mobile drawers.

### Non-Filter Accordion

- `app/frontend/components/AccordionGroup.vue`
  - Generic accordion component.
  - May be used outside filters, notably in the mobile navigation menu.
  - Do not remove or globally alter it when changing filter UI.

## Page Consumers

- `app/frontend/pages/ProgramPage.vue`
  - Uses `ResponsiveFilterMenu` with `ProgramsFilterForm`.
  - Uses `useSearchFilter` for filter state and Inertia navigation.
  - Displays active filter tags separately on mobile and desktop.

- `app/frontend/pages/Mostras/Show.vue`
  - Current-edition showcase shell (`MenuContext nav="edicao"`).
  - Delegates the filterable listing body to `MostraShowContent`.

- `app/frontend/pages/Edicoes/Mostras/Show.vue`
  - Previous-edition showcase detail page (`EdicaoHeader`, `MenuContext
    nav="edicoes_anteriores"`), used by both the Première Brasil special route
    and regular historical showcase permalinks.
  - Reuses `MostraShowContent` for filters and film cards; `tabBaseUrl` points
    to `/edicoes_anteriores/:edicao_id/mostras/premiere-brasil` for Première Brasil
    or `/edicoes_anteriores/:edicao_id/mostras/:permalink` for regular
    historical showcases.
  - Passes `filmCardsLinkable=false` so historical film cards stay
    non-clickable until a historical film detail route exists.

- `app/frontend/pages/Edicoes/Filmes.vue`
  - Uses `SearchFilter` directly inside a page-owned drawer instead of
    `ResponsiveFilterMenu`.
  - Uses `MostrasFilterForm`.
  - Also manages sort state, so filter navigation must preserve the sort param.

- `app/frontend/pages/Edicoes/Noticias.vue`
  - Previous-edition news listing (`EdicaoHeader`, `MenuContext
    nav="edicoes_anteriores"`).
  - Uses `SearchFilter` directly inside a page-owned drawer and
    `NoticiasFilterForm` for `data`, `caderno`, and `query`.
  - Rails scopes the base news relation by the selected `Edicao` date range
    before applying filters.
  - Also manages sort state, so filter navigation must preserve the `sort`
    param alongside `query`, `data`, and `caderno`.

- `app/frontend/pages/Noticias/Index.vue`
  - Uses `ResponsiveFilterMenu` with `NoticiasFilterForm`.
  - Uses the shared filter composable and active filter tags.

## State and Navigation Flow

1. Rails controllers render pages with:
   - filter option collections;
   - `current_filters`;
   - `tabBaseUrl`;
   - list data (`elements`, `pagy`, etc.).
2. The page initializes local filter state from `current_filters`.
3. `SearchFilter` receives that state through `modelValue`.
4. Page-specific forms call `updateField(key, selectedFilterObject)`.
5. The user applies filters.
6. The page/composable converts selected filter objects to URL params.
7. `router.get(tabBaseUrl, params, options)` updates the URL and requests fresh
   server-owned props.
8. The server returns updated `current_filters`, list props, pagination data,
   and active-filter metadata.

For infinite-scroll pages, filter navigation must keep the first-page URL and
pagination props consistent. Do not update the visual filter state without also
considering how `InfiniteScrollLayout` will read the current URL params for
subsequent pages.

Pages with ordering controls, such as previous-edition films and news, preserve
`sort` as page-owned URL state whenever filters or search terms are applied.

## Clearing and Removing Filters

- Clearing all filters should reset local state and navigate back to the
  unfiltered listing when filters were applied.
- Removing one tag should clear the matching key from local state and navigate
  with the remaining filters.
- Be careful with label-to-key mapping in `useSearchFilter`; it currently maps
  human labels such as `Mostra`, `Genre`, `Country`, and `Caderno` back to
  filter keys.

## Responsive Behavior

### Desktop

- Most pages render filters in a visible sticky area beside the content.
- Active filter tags are shown near the listing content.
- Page-specific layout classes determine the exact grid placement.

### Mobile

- Filters open from `MobileTrigger`.
- The drawer should cover the viewport.
- Filter content should scroll independently.
- Apply/clear actions should remain sticky at the bottom.
- Closing the drawer should restore body scroll.

## Maintenance Rules

- Keep filter options server-owned. Do not introduce client-side fetching for
  filter option lists.
- Preserve URL-driven applied filter state.
- Preserve Inertia navigation and partial reload behavior unless the task is
  explicitly about changing it.
- Do not change the filter object shape without updating controllers, frontend
  helpers, tags, and tests together.
- Do not remove `AccordionGroup.vue` just because filters no longer use it; it
  can still be valid for non-filter UI.
- If a visual change affects all filter forms, check every page consumer before
  assuming a single shared form covers the whole site.
- When adding a filter field, update both the controller props and the
  page-specific form, and add tests for URL params/current filters.

## Testing Expectations

When changing filter structure or behavior, add or update tests that cover:

- filter fields render with their labels;
- filter wrappers do not introduce unwanted interactive behavior;
- applying filters sends the expected URL params;
- clearing/removing filters preserves the expected remaining params;
- mobile drawer actions remain available with long filter lists;
- page-specific behavior such as previous-edition sorting or programming tabs.

Useful existing test locations:

- `app/frontend/lib/__tests__/filterUtils.test.js`
- `app/frontend/tests/`
- Rails controller/request tests under `test/`

## Related Files

- `app/frontend/lib/filterUtils.js`
- `app/frontend/lib/applyFiltersToQuery.js`
- `app/frontend/components/common/tags/TagFilter.vue`
- `app/frontend/components/layout/InfiniteScrollLayout.vue`
- Rails listing controllers that provide filter props and `current_filters`
