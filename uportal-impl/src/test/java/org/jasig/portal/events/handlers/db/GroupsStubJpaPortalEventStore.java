/**
 * Copyright (c) 2000-2009, Jasig, Inc.
 * See license distributed with this file and available online at
 * https://www.ja-sig.org/svn/jasig-parent/tags/rel-10/license-header.txt
 */
package org.jasig.portal.events.handlers.db;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.jasig.portal.groups.GroupsException;
import org.jasig.portal.security.IPerson;

/**
 * @author Eric Dalquist
 * @version $Revision$
 */
public class GroupsStubJpaPortalEventStore extends JpaPortalEventStore implements ITestablePortalEventStore {
    private Map<IPerson, Set<String>> personGroups = new HashMap<IPerson, Set<String>>();
    
    /**
     * @return the personGroups
     */
    public Map<IPerson, Set<String>> getPersonGroups() {
        return personGroups;
    }
    /**
     * @param personGroups the personGroups to set
     */
    public void setPersonGroups(Map<IPerson, Set<String>> personGroups) {
        this.personGroups = personGroups;
    }
    
    public void addPersonGroups(IPerson person, Set<String> groups) {
        this.personGroups.put(person, groups);
    }


    /* (non-Javadoc)
     * @see org.jasig.portal.events.handlers.db.JpaPortalEventStore#updateStatsSessionGroups(org.jasig.portal.events.handlers.db.StatsSession, org.jasig.portal.security.IPerson)
     */
    @Override
    protected void updateStatsSessionGroups(StatsSession session, IPerson person) throws GroupsException {
        final Set<String> groups = this.personGroups.get(person);
        session.setGroups(groups);
    }

}
