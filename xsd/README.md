# Notes about E-Invoice

- The scheme files for E-Invoicing are disassembled; no direct validation possible
- The validating XSL file had been assembled from schematron files by the author
- However, this assembly is not reproducible from neither of the files available in the varios "cajas de herramientas" (toolkits)

# Notes about E-Invoice

- The Nomina can be validated against the schema file with the below command
- Howerver, the example file from the caja de herramientas (nomina) doesn't conform to the schema

```console
xmllint --schema xsd/maindoc/NominaIndividualElectronicaXSDV1.0.6.xsd bench/Nomina\ Individual\ Electronica\ V1.0.1.xml --noout
```

**Result**

```console
❯ xmllint --schema xsd/maindoc/NominaIndividualElectronicaXSDV1.0.6.xsd bench/Nomina\ Individual\ Electronica\ V1.0.1.xml --noout
bench/Nomina%20Individual%20Electronica%20V1.0.1.xml:12: element UBLExtensions: Schemas validity error : Element '{urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2}UBLExtensions': Missing child element(s). Expected is ( {urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2}UBLExtension ).
bench/Nomina%20Individual%20Electronica%20V1.0.1.xml:92: element Transporte: Schemas validity error : Element '{dian:gov:co:facturaelectronica:NominaIndividual}Transporte', attribute 'ViaticoManutAlojS': The attribute 'ViaticoManutAlojS' is not allowed.
bench/Nomina%20Individual%20Electronica%20V1.0.1.xml:92: element Transporte: Schemas validity error : Element '{dian:gov:co:facturaelectronica:NominaIndividual}Transporte', attribute 'ViaticoManutAlojNS': The attribute 'ViaticoManutAlojNS' is not allowed.
bench/Nomina%20Individual%20Electronica%20V1.0.1.xml:228: element FondoSP: Schemas validity error : Element '{dian:gov:co:facturaelectronica:NominaIndividual}FondoSP', attribute 'Deduccion': The attribute 'Deduccion' is not allowed.
bench/Nomina Individual Electronica V1.0.1.xml fails to validate
```
