package org.jasig.portal.layout;

import org.jasig.portal.PortalException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;


/**
 * An class describing common features of user layout nodes,
 * that is channels and folders
 *
 * @author <a href="mailto:pkharchenko@interactivebusiness.com">Peter Kharchenko</a>
 * @version 1.0
 */
public abstract class UserLayoutNodeDescription {
    protected String id=null;
    protected String name=null;
    protected boolean immutable=false;
    protected boolean unremovable=false;
    protected boolean hidden=false;

    public static final String ROOT_FOLDER_ID="root";
    
    /**
     * Returns a node Id. 
     * The Id has to be unique in the entire user layout document.
     *
     * @return a <code>String</code> value
     */
    public String getId() {
        return this.id;
    }

    /**
     * Set a new node Id.
     * The Id has to be unique in the entire user layout document.
     *
     */
    public void setId(String id) {
        this.id=id;
    }

    /**
     * Determine a name associated with this node.
     *
     * @return a folder/channel name.
     */
    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name=name;
    }

    public boolean isUnremovable() {
        return this.unremovable;
    }
    public void setUnremovable(boolean setting) {
        this.unremovable=setting;
    }

    public boolean isImmutable() {
        return this.immutable;
    } 
    public void setImmutable(boolean setting) {
        this.immutable=setting;
    }

    public boolean isHidden() {
        return this.hidden;
    }
    public void setHidden(boolean setting) {
        this.hidden=setting;
    }

    
    /**
     * Creates a <code>org.w3c.dom.Element</code> representation of the current node.
     *
     * @param root a <code>Document</code> for which the <code>Element</code> should be created.
     * @return a <code>Element</code> value
     */
    public abstract Element getXML(Document root);

    /**
     * Add all of common node attributes to the <code>Element</code>.
     *
     * @param node an <code>Element</code> value
     */
    protected void addNodeAttributes(Element node) {
        node.setAttribute("ID",this.getId());
        node.setAttribute("name",this.getName());
        node.setAttribute("unremovable",(new Boolean(this.isUnremovable())).toString());
        node.setAttribute("immutable",(new Boolean(this.isImmutable())).toString());
        node.setAttribute("hidden",(new Boolean(this.isHidden())).toString());
    }

    /**
     * A factory method to create a <code>UserLayoutNode</code> instance,
     * based on the information provided in the user layout <code>Element</code>.
     *
     * @param xmlNode a user layout DTD folder/channel <code>Element</code> value
     * @return an <code>UserLayoutNode</code> value
     * @exception PortalException if the xml passed is somehow invalid.
     */
    public static UserLayoutNodeDescription createUserLayoutNodeDescription(Element xmlNode) throws PortalException {
        // is this a folder or a channel ?
        String nodeName=xmlNode.getNodeName();
        if(nodeName.equals("channel")) {
            return new UserLayoutChannelDescription(xmlNode);
        } else if(nodeName.equals("folder")) {
            return new UserLayoutFolderDescription(xmlNode);
        } else if(nodeName.equals("layout")) {
            // root node
            return new UserLayoutRootDescription(xmlNode);
        } else {
            throw new PortalException("Given XML element is neither folder nor channel");
        }
    }

}
