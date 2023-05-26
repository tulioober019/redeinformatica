/*Pedir los coeficientes de una ecuación se 2º grado, y muestre sus soluciones reales. Si no existen,
debe indicarlo.*/
import java.util.Scanner;
public class Calculadora_ecu_2grado {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner entrada_datos=new Scanner(System.in);
		
		double a=Double.NaN;
		double b=Double.NaN;
		double c=Double.NaN;
		
			while (Double.isNaN(a)==true && Double.isNaN(b)==true && Double.isNaN(b)==true) {
				System.out.println("Mete os valores dos coeficientes:");
				System.out.print("Coeficiente a: ");
				a=entrada_datos.nextDouble();
				
				System.out.print("Coeficiente b: ");
				b=entrada_datos.nextDouble();
				
				System.out.print("Coeficiente c: ");
				c=entrada_datos.nextDouble();
				
				double solucion1=(-b+(Math.sqrt(Math.pow(b, 2)-4*a*c)))/(2*a);
				double solucion2=(-b-(Math.sqrt(Math.pow(b, 2)-4*a*c)))/(2*a);
				
				if (Double.isNaN(solucion1)==true) {
					System.out.println("No hay resultado para la primera solucion.");
				}
				else {
					System.out.println("Solucion1 = " + solucion1);
				}
				
				
				if (Double.isNaN(solucion2)==true) {
					System.out.println("No hay resultado para la segunda solucion.");
				}
				else {
					System.out.println("Solucion2 = " + solucion2);
				}
				
				a=Double.NaN;
				b=Double.NaN;
				c=Double.NaN;
				
		}

	}

}
