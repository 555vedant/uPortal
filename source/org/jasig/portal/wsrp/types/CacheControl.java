/**
 * CacheControl.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis WSDL2Java emitter.
 */

package org.jasig.portal.wsrp.types;

public class CacheControl  implements java.io.Serializable {
    private int expires;
    private java.lang.String userScope;
    private java.lang.String validateTag;
    private org.jasig.portal.wsrp.types.Extension[] extensions;

    public CacheControl() {
    }

    public int getExpires() {
        return expires;
    }

    public void setExpires(int expires) {
        this.expires = expires;
    }

    public java.lang.String getUserScope() {
        return userScope;
    }

    public void setUserScope(java.lang.String userScope) {
        this.userScope = userScope;
    }

    public java.lang.String getValidateTag() {
        return validateTag;
    }

    public void setValidateTag(java.lang.String validateTag) {
        this.validateTag = validateTag;
    }

    public org.jasig.portal.wsrp.types.Extension[] getExtensions() {
        return extensions;
    }

    public void setExtensions(org.jasig.portal.wsrp.types.Extension[] extensions) {
        this.extensions = extensions;
    }

    public org.jasig.portal.wsrp.types.Extension getExtensions(int i) {
        return extensions[i];
    }

    public void setExtensions(int i, org.jasig.portal.wsrp.types.Extension value) {
        this.extensions[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CacheControl)) return false;
        CacheControl other = (CacheControl) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.expires == other.getExpires() &&
            ((this.userScope==null && other.getUserScope()==null) || 
             (this.userScope!=null &&
              this.userScope.equals(other.getUserScope()))) &&
            ((this.validateTag==null && other.getValidateTag()==null) || 
             (this.validateTag!=null &&
              this.validateTag.equals(other.getValidateTag()))) &&
            ((this.extensions==null && other.getExtensions()==null) || 
             (this.extensions!=null &&
              java.util.Arrays.equals(this.extensions, other.getExtensions())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        _hashCode += getExpires();
        if (getUserScope() != null) {
            _hashCode += getUserScope().hashCode();
        }
        if (getValidateTag() != null) {
            _hashCode += getValidateTag().hashCode();
        }
        if (getExtensions() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getExtensions());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getExtensions(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CacheControl.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "CacheControl"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("expires");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "expires"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userScope");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "userScope"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("validateTag");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "validateTag"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("extensions");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "extensions"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "Extension"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
