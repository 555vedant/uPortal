/**
 * Copyright (c) 2000-2009, Jasig, Inc.
 * See license distributed with this file and available online at
 * https://www.ja-sig.org/svn/jasig-parent/tags/rel-10/license-header.txt
 */
package org.jasig.portal.layout.dlm;

import java.util.Enumeration;
import java.util.NoSuchElementException;

/**
 * @version $Revision$ $Date$
 * @since uPortal 2.5
 */
public class CompositeEnumeration
    implements Enumeration
{
    public static final String RCS_ID = "@(#) $Header$";

    private Enumeration first = null;
    private Enumeration second = null;

    /**
     * Constructs an enumeration object that enumerates over the elements
     * in the first passed in enumeration object and then enumerates over
     * those in the second passed in enumeration object. 
     */
    CompositeEnumeration( Enumeration first,
                          Enumeration second )
    {
        this.first = first;
        this.second = second;
    }

    public boolean hasMoreElements()
    {
        return first.hasMoreElements() || second.hasMoreElements();
    }

    public Object nextElement()
        throws NoSuchElementException
    {
        if ( first.hasMoreElements() )
            return first.nextElement();
        return second.nextElement();
    }
}
