/**
 * DestroyPortletsResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis WSDL2Java emitter.
 */

package org.jasig.portal.wsrp.types;

public class DestroyPortletsResponse  implements java.io.Serializable {
    private org.jasig.portal.wsrp.types.DestroyFailed[] destroyFailed;
    private org.jasig.portal.wsrp.types.Extension[] extensions;

    public DestroyPortletsResponse() {
    }

    public org.jasig.portal.wsrp.types.DestroyFailed[] getDestroyFailed() {
        return destroyFailed;
    }

    public void setDestroyFailed(org.jasig.portal.wsrp.types.DestroyFailed[] destroyFailed) {
        this.destroyFailed = destroyFailed;
    }

    public org.jasig.portal.wsrp.types.DestroyFailed getDestroyFailed(int i) {
        return destroyFailed[i];
    }

    public void setDestroyFailed(int i, org.jasig.portal.wsrp.types.DestroyFailed value) {
        this.destroyFailed[i] = value;
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
        if (!(obj instanceof DestroyPortletsResponse)) return false;
        DestroyPortletsResponse other = (DestroyPortletsResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.destroyFailed==null && other.getDestroyFailed()==null) || 
             (this.destroyFailed!=null &&
              java.util.Arrays.equals(this.destroyFailed, other.getDestroyFailed()))) &&
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
        if (getDestroyFailed() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getDestroyFailed());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getDestroyFailed(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
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
        new org.apache.axis.description.TypeDesc(DestroyPortletsResponse.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "DestroyPortletsResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("destroyFailed");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "destroyFailed"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:oasis:names:tc:wsrp:v1:types", "DestroyFailed"));
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
