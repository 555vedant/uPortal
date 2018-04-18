/**
 * Licensed to Apereo under one or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information regarding copyright ownership. Apereo
 * licenses this file to you under the Apache License, Version 2.0 (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of the License at the
 * following location:
 *
 * <p>http://www.apache.org/licenses/LICENSE-2.0
 *
 * <p>Unless required by applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apereo.portal.soffit.renderer;

import org.apereo.portal.soffit.ITokenizable;

/**
 * Thrown when a Soffit attempts to use a data model element that is not present in the request from
 * the <code>SoffitConnectorController</code>. Desired model attributes must be listed in the
 * portlet publication record.
 *
 * @since 5.1
 */
public class MissingModelElementException extends RuntimeException {

    public MissingModelElementException(Class<? extends ITokenizable> attributeClass) {
        super(
                "Soffit data model attribute requested but missing from the request header: "
                        + attributeClass.getSimpleName());
    }
}
