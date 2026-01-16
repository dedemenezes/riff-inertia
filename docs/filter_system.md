# 🎯 Refactored Filter System Usage Guide

## ✅ **What Changed**

### **Before**: Complex, Hard to Reuse
- **3 components** with filter logic: ProgramPage, ResponsiveFilterMenu, SearchFilter
- **Duplicate `updateField`** functions everywhere
- **Console logs** from ResponsiveFilterMenu
- **Hard to reuse** - tightly coupled components

### **After**: Clean, Reusable Architecture
- **1 component** with filter logic: SearchFilter (single source of truth)
- **ResponsiveFilterMenu**: Pure layout component (100% reusable)
- **ProgramPage**: Just handles router calls and main state
- **Console logs** only from SearchFilter
- **Easy to reuse** - clear component boundaries

---

## 🚀 **How Your Colleagues Can Reuse It**

### **Simple Usage**: Just SearchFilter
```vue
<script setup>
import SearchFilter from '@/components/features/filters/SearchFilter.vue'
import MyCustomForm from './MyCustomForm.vue'

const filters = ref({
  category: null,
  price: null,
  location: null
})

const handleApply = (cleanedFilters) => {
  // Make your API call
  api.search(cleanedFilters)
}

const handleClear = (clearedFilters) => {
  // Handle cleared state
  filters.value = clearedFilters
}
</script>

<template>
  <SearchFilter
    v-model="filters"
    @filters-applied="handleApply"
    @filters-cleared="handleClear"
  >
    <template #filters="{ updateField, clearField, hasActiveFilters }">
      <MyCustomForm
        :filters="filters"
        :update-field="updateField"
        :clear-field="clearField" <!-- only if needed -->
        :has-active-filters="hasActiveFilters" <!-- only if needed -->
      />
    </template>
  </SearchFilter>
</template>
```

### **Advanced Usage**: With ResponsiveFilterMenu Layout
```vue
<script setup>
import { useMobileTrigger } from "@/components/features/filters/composables/useMobileTrigger";
const { isFilterMenuOpen, openMenu, closeMenu } = useMobileTrigger();

import ResponsiveFilterMenu from '@/components/features/filters/ResponsiveFilterMenu.vue'
import MyCustomForm from './MyCustomForm.vue'

const filters = ref({ /* your filter structure */ })
</script>

<template>
  <!-- Mobile trigger -->
  <div class="filter flex lg:hidden items-center justify-end py-300 bg-white">
    <MobileTrigger @open-menu="openMenu" />
  </div>

  <!-- Responsive filter system -->
  <ResponsiveFilterMenu
    v-model="filters"
    :is-open="isFilterMenuOpen"
    @filters-applied="handleApply"
    @filters-cleared="handleClear"
    @close-filter-menu="isFilterMenuOpen = false"
  >
    <template #filters="searchFilterProps">
      <MyCustomForm
        :filters="filters"
        :update-field="updateField"
        :clear-field="clearField" <!-- only if needed -->
        :has-active-filters="hasActiveFilters" <!-- only if needed -->
      />
    </template>
  </ResponsiveFilterMenu>
</template>
```

---

## 🔧 **SearchFilter Props & Events**

### **Props**
- `modelValue` (Object, required): Filter state object

### **Events**
- `@update:modelValue`: Emitted when any filter changes
- `@filtersApplied`: Emitted when user applies filters (cleaned data)
- `@filtersCleared`: Emitted when user clears all filters
- `@close-filter-menu`: Emitted to close mobile menu

### **Slot Props** (`#filters`)
```javascript
{
  modelValue,              // Current filter values
  updateField,             // (key, value) => update single field
  clearField,              // (key) => clear single field
  hasActiveFilters,        // Boolean - any filters active
}
```

### **Slot Props** (`#actions`)
```javascript
{
  hasActiveFilters,        // Boolean - any filters active
  applyFilters,            // () => apply current filters
  clearAllFilters          // () => clear all filters
}
```

---

## 📱 **ResponsiveFilterMenu Features**

### **What It Provides**
- **Desktop**: Sticky sidebar layout
- **Mobile**: Fullscreen modal with slide animation
- **Responsive**: Automatically switches between layouts
- **Accessibility**: Proper ARIA labels and keyboard support

### **Props**
- `modelValue` (Object, required): Filter state
- `isOpen` (Boolean, required): Mobile menu open state
- `debugMode` (Boolean, optional): Show debug info

### **Events**
- All SearchFilter events (passed through)
- `@close-filter-menu`: Close mobile menu

---

## 🎨 **Example Custom Form Component**

```vue
<!-- MyProductFilters.vue -->
<script setup>
const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  mostras: { type: Array, default: () => [] }, // Program-specific prop
  cinemas: { type: Array, default: () => [] }, // Program-specific prop
  // ...
})

const mostrasFilterOptions = computed(() => mapFilterOptions(props.mostras));
const mostraLabel = computed(() => props.mostras[0].filter_label)

const actorsFilterOptions = computed(() => mapFilterOptions(props.actors));
const actorsLabel = computed(() => props.actors[0]?.filter_label)
// ...
</script>

<template>
  <div class="space-y-4">
    <!-- Search input -->
    <input
      :value="modelValue.query || ''"
      @input="updateField('query', $event.target.value)"
      placeholder="Search products..."
    />

    <!-- Category select -->
    <label>{{ mostraLabel }}</label>
    <select
      :value="modelValue.mostra || ''"
      @change="updateField('mostra', $event.target.value)"
    >
      <option v-if="mostra in props.mostras" :value="mostra.filter_value">{{ mostral.filter_display }}</option>
      <option value="electronics">Electronics</option>
      <option value="clothing">Clothing</option>
    </select>
  </div>
</template>
```

---

## 🧪 **Console Log Changes**

### **Before**: Confusing Logs
```
ResponsiveFilterMenu updating mostra: {...}  ❌
ResponsiveFilterMenu updating cinema: {...}  ❌
```

### **After**: Clear Logs
```
SearchFilter updating mostra: {...}  ✅
SearchFilter updating cinema: {...}  ✅
SearchFilter applying filters: {...}  ✅
SearchFilter clearing all filters     ✅
```

---

## 🔄 **Migration from Old System**

### **If you were using ResponsiveFilterMenu before:**

```vue
<!-- OLD -->
<ResponsiveFilterMenu
  v-model="filters"
  :initialFilters="localFilters"  ❌ Remove this
  :is-open="isOpen"
>

<!-- NEW -->
<ResponsiveFilterMenu
  v-model="filters"
  :is-open="isOpen"
>
```

### **If you had updateField in parent component:**
```javascript
// OLD - Remove this function ❌
const updateField = (key, value) => {
  filters.value[key] = value
}

// NEW - SearchFilter handles this via slot props ✅
// No updateField needed in parent!
```

---

## 🎯 **Benefits for Your Team**

### **For Developers**
- **Single place** to debug filter logic (SearchFilter)
- **Reusable components** for any filtering needs
- **Clear separation** of concerns
- **Better testing** - mock one component instead of three

### **For New Projects**
- **Drop-in filtering** - just import SearchFilter
- **Responsive by default** - use ResponsiveFilterMenu wrapper
- **Customizable** - slots for any form structure
- **Type-safe** - clear prop and event interfaces

### **For Maintenance**
- **One place** to fix filter bugs (SearchFilter)
- **Consistent behavior** across all filter implementations
- **Easy to extend** - add new slot props as needed

---
