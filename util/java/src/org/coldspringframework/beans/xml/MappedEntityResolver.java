/*
 * Copyright 2010 Mark Mandel
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
 */

package org.coldspringframework.beans.xml;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Map;

import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * Resolves XSD entities against their local paths 
 * 
 * @author Mark Mandel
 *
 */
public class MappedEntityResolver implements EntityResolver
{
	private Map<String, String> entityMap;
	
	/**
	 * 
	 * @param entityMap
	 */
	public MappedEntityResolver(Map<String, String> entityMap)
	{
		setEntityMap(entityMap);
	}
	
	@Override
	public InputSource resolveEntity(String publicId, String systemId) throws SAXException, IOException
	{
		//System id is the one that points to the XSD path.
		if(getEntityMap().containsKey(systemId))
		{
			FileInputStream inputStream = new FileInputStream(getEntityMap().get(systemId));
			
			return new InputSource(inputStream);
		}
		
		return null;
	}

	private Map<String, String> getEntityMap()
	{
		return entityMap;
	}

	private void setEntityMap(Map<String, String> entityMap)
	{
		this.entityMap = entityMap;
	}
}
