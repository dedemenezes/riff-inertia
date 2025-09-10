import { describe, it, expect } from 'vitest'
import { extractFilterValues } from '../filterUtils.js'

describe('extractFilterValues', () => {
  it('should extract filter_value from valid filter objects', () => {
    const input = {
      status: { filter_value: 'active', filter_display: 'Active' },
      priority: { filter_value: 'high', filter_display: 'High' },
    }

    const expected = {
      status: 'active',
      priority: 'high',
    }

    expect(extractFilterValues(input)).toEqual(expected)
  })

  it('should ignore null or undefined values', () => {
    const input = {
      status: null,
      type: undefined,
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should ignore objects without filter_value', () => {
    const input = {
      category: { filter_display: 'Category A' },
      type: { some_key: 'some_value' },
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should ignore primitive values like strings or numbers', () => {
    const input = {
      search: 'query',
      count: 5,
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should handle mixed types and only extract valid filter_values', () => {
    const input = {
      status: { filter_value: 'active', filter_display: 'Active' },
      category: null,
      type: { filter_display: 'Type A' },
      priority: { filter_value: 'high', filter_display: 'High' },
      search: 'query'
    }

    const expected = {
      status: 'active',
      priority: 'high'
    }

    expect(extractFilterValues(input)).toEqual(expected)
  })

  it('should extract falsy but valid filter_value values like 0 and false', () => {
    const input = {
      zero: { filter_value: 0, filter_display: 'Zero' },
      boolFalse: { filter_value: false, filter_display: 'False' },
    }

    const expected = {
      zero: 0,
      boolFalse: false,
    }

    expect(extractFilterValues(input)).toEqual(expected)
  })

  it('should ignore filters where filter_value is null or undefined', () => {
    const input = {
      a: { filter_value: null, filter_display: 'Null' },
      b: { filter_value: undefined, filter_display: 'Undefined' },
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should ignore filter objects where filter_value is an array or object', () => {
    const input = {
      a: { filter_value: [], filter_display: 'Array' },
      b: { filter_value: { some: 'thing' }, filter_display: 'Object' },
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should ignore completely invalid types (e.g., arrays, booleans)', () => {
    const input = {
      array: [],
      bool: true,
      number: 42,
      string: 'some text',
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should include "query" key as-is if it is a string', () => {
    const input = {
      query: 'search term',
    }

    const expected = {
      query: 'search term',
    }

    expect(extractFilterValues(input)).toEqual(expected)
  })

  it('should ignore "query" if it is not a string', () => {
    const input = {
      query: 123,
    }

    expect(extractFilterValues(input)).toEqual({})
  })

  it('should extract both valid filter_value and valid "query"', () => {
    const input = {
      status: { filter_value: 'active', filter_display: 'Active' },
      query: 'user search',
    }

    const expected = {
      status: 'active',
      query: 'user search',
    }

    expect(extractFilterValues(input)).toEqual(expected)
  })

  it('should not allow non-query keys with non-object values', () => {
    const input = {
      query: 'allowed',
      badKey: 'not allowed',
      another: 123,
    }

    const expected = {
      query: 'allowed',
    }

    expect(extractFilterValues(input)).toEqual(expected)
  })
})
