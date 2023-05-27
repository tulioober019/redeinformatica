package CalculadoraEcuacionsSegundoGrado;
//import java.util.*;
public class Variables {

	public Variables(double variableA,double variableB,double variableC) {
		if (Double.isNaN(variableA)==false && Double.isNaN(variableB)==false && Double.isNaN(variableC)==false) {
			
			double resul_1;
			resul_1=(-variableB+Math.sqrt(Math.pow(variableB, 2)-4*variableA*variableC))/(2*variableA);
			
			if (Double.isNaN(resul_1)==false) {
				
				System.out.println("El primer resultado es: " + resul_1);
			}
			
			else {
				
				System.out.println("No hay resultado para la primera solución. :(");
			}
			
			double resul_2;
			resul_2=(-variableB-Math.sqrt(Math.pow(variableB, 2)-4*variableA*variableC))/(2*variableA);
			
			if (Double.isNaN(resul_2)==false) {
				
				System.out.println("El segundo resultado es: " + resul_1);
			}
			
			else {
				
				System.out.println("No hay resultado para la segunda solución. :(");
			}
		}
	}
}