package CalculadoraEcuacionsSegundoGrado;

import java.util.Scanner;

public class Calculadora {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		@SuppressWarnings("resource")
		Scanner entrada=new Scanner(System.in);
		
		System.out.println("Calculadora CLI de ecuaciones de segundo grado.\n");
		double varA=Double.NaN;
		double varB=Double.NaN;
		double varC=Double.NaN;
		
		while (Double.isNaN(varA)==true && Double.isNaN(varB)==true && Double.isNaN(varC)==true) {
			System.out.print("Coeficiente A: ");
			varA=entrada.nextDouble();
			
			System.out.println("");
			System.out.print("Coeficiente B: ");
			varB=entrada.nextDouble();
			
			System.out.println("");
			System.out.print("Coeficiente C: ");
			varC=entrada.nextDouble();
			
			System.out.println("");
			
			@SuppressWarnings("unused")
			Variables calculo=new Variables(varA,varB,varC);
			
			varA=Double.NaN;
			varB=Double.NaN;
			varC=Double.NaN;
		}
	}

}
