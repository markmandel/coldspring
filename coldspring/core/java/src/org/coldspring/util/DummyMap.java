/**
 * 
 */
package org.coldspring.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Dummy Map, that stores nothing, and returns nothing except null, ever
 * 
 * @author Mark Mandel
 *
 */
public class DummyMap<K, V> implements Map<K, V> 
{
	public DummyMap() {}
	
	public void clear() {}
	
	public boolean containsKey(Object key)
	{
		return false;
	}
	
	public boolean containsValue(Object value)
	{
		return false;
	}
	
	public Set<Map.Entry<K,V>> entrySet()
	{
		return new HashSet<Entry<K,V>>();
	}
	
	public boolean equals(Object object)
	{
		return super.equals(object);
	}
	
	public V get(Object key)
	{
		return null;
	}
	
	public int hashCode()
	{
		return super.hashCode();
	}
	
	public boolean isEmpty()
	{
		return true;
	}
	
	public Set<K> keySet()
	{
		return new HashSet<K>();
	}
	
	public V put(K key, V value)
	{
		return null;
	}
	
	public void putAll(Map<? extends K,? extends V> m ){}
	
	public V remove(Object key)
	{
		return null;
	}
	
	public int size()
	{
		return 0;
	}
	
	public Collection<V> values()
	{
			return new HashSet<V>();
	}
}
