
#include <SPI.h>
#include <MFRC522.h>
#include <MySQL_Connection.h>
#include <MySQL_Cursor.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>

#define SS_PIN 15
#define RST_PIN 0

MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.




char ssid[] = "pepita(terreo)";                 // Network Name
char pass[] = "28092016";                 // Network Password
//byte mac[6];
// NETWORK: Static IP details...
IPAddress ip(192, 168, 88, 101);
IPAddress gateway(192, 168, 88, 1);
IPAddress subnet(255, 255, 255, 0);


WiFiClient client;
MySQL_Connection conn((Client *)&client);

String query = "";

char query1[255];
char query2[128];
char query3[128];
char query4[128];



String UID = "";            // UID RFID Scan
String Username = "";       // Name Retorno query
//String RUID = "";           // UID retorno query
unsigned int aptNumber;          // Numero APTO Retorno query
unsigned int VDisp;              // Vagas Disponiveis Retorno query
String UserStatus = "";     // Suatus Usuário Retorno query

#define redled 10
#define greenled 9
#define boardled 16

IPAddress server_addr(192, 168, 88, 11);       // MySQL server IP
char user[] = "rfid";           // MySQL user
char password[] = "12341234";       // MySQL password

void setup() //--INICIO DO SETUP--//
{
  Serial.begin(9600);   // Initiate a serial communication

  Serial.print("Conectando a: ");
  Serial.println(ssid);
  //WiFi.config(ip, gateway, subnet);
  WiFi.begin(ssid, pass);

  while (WiFi.status() != WL_CONNECTED) {
    delay(200);
    Serial.print(".");

  }

  pinMode(redled, OUTPUT);
  pinMode(greenled, OUTPUT);
  pinMode(boardled, OUTPUT);

  digitalWrite(redled, LOW);
  digitalWrite(greenled, LOW);
  digitalWrite(boardled, LOW);

  Serial.println("");
  Serial.println("WiFi Conectado");

  Serial.print("Ip Recebido: ");
  Serial.print(WiFi.localIP());
  Serial.println("");

  Serial.println("Conectanco ao Banco");

  while (conn.connect(server_addr, 3306, user, password) != true) {
    delay(200);
    Serial.print ( "." );

    digitalWrite(boardled, HIGH);
  }
  Serial.println("");
  Serial.println("Conectado ao MySQL Server!");


  SPI.begin();      // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522
  Serial.println("Aproxime sua TagID...");
  Serial.println();

} //--FIM DO SETUP--//

void check(String UID)
{

  int flag = 0;
  Serial.println(UID);
  query = "SELECT users.num_apto, users.name, apto.num_apto, apto.VagasDisp, users.UID FROM rfid.users, rfid.apto WHERE users.num_apto = apto.num_apto AND UID=\"" + UID + "\"";
  strcpy(query1, query.c_str());
  MySQL_Cursor *cur_mem = new MySQL_Cursor(&conn);
  cur_mem->execute(query1);
  column_names *cols = cur_mem->get_columns();
  row_values *row = NULL; // Read the rows and print them
  row = cur_mem->get_next_row();
  
  while (row != NULL) {
    aptNumber = atol(row->values[0]);
    Username = (row->values[1]);
    VDisp = atol(row->values[3]);
    //RUID = (row->values[4]);
    row = cur_mem->get_next_row();
  }
  
 query = ""; //delete cur_mem;

  if (VDisp > 0 && Username != NULL) {
    flag = 1;
    Serial.println("Acesso Autorizado :)");
  }

  else if (VDisp == 0 && Username != NULL) {
    flag = 0;
    Serial.print("Acesso Negado! ");
    Serial.println("Todas as vagas ocupadas");
  } else {
    flag = 2;
  }

  if (flag == 2) {
    digitalWrite(redled, HIGH);
    delay(250);
    digitalWrite(redled, LOW);
    delay(250);
    digitalWrite(redled, HIGH);
    delay(250);
    digitalWrite(redled, LOW);
    
    Serial.print("Cartão NÃO registrado: ");
    Serial.println(UID);
    
    flag = 2;
    query = "";
    row = NULL;
  }

  if (flag == 1) {
    digitalWrite(greenled, HIGH);
    delay(500);
    digitalWrite(greenled, LOW);
    Serial.print("Apartamento: ");
    Serial.println(aptNumber);
    Serial.print("Morador: ");
    Serial.println(Username);
    Serial.print("Vagas Disponiveis: ");
    Serial.println(VDisp);
    
    query = "INSERT INTO rfid.history (UID,Name,num_apto,Dtime,Act) VALUES('" + UID + "','" + Username + "','" + aptNumber + "',NOW(),'Entrada')";
    strcpy(query2, query.c_str());
    cur_mem->execute(query2);
    column_names *cols = cur_mem->get_columns(); // Read the rows and print them      
    delay(500);
    Serial.print("Atualizando Vagas... ");
    Serial.print(" ");
    Serial.print("Vagas Disponiveis: ");
    Serial.println(VDisp);
    row = NULL;
    query = "";
  }

  if (flag == 0) {
    digitalWrite(redled, HIGH);
    delay(500);
    digitalWrite(redled, LOW);
    Serial.print("Apartamento: ");
    Serial.println(aptNumber);
    Serial.print("Morador: ");
    Serial.println(Username);
    Serial.print("Vagas Disponiveis: ");
    Serial.println(VDisp);
    query = "INSERT INTO rfid.history (UID,Name,num_apto,Dtime,Act) VALUES('" + UID + "','" + Username + "','" + aptNumber + "',NOW(),'Saida')";
    strcpy(query3, query.c_str());
    cur_mem->execute(query3);
    column_names *cols = cur_mem->get_columns();

    // Read the rows and print them
    row = NULL;
  }


  query = "";            // Apagando consulta
  delete cur_mem;       //Liberando memoria
  conn.close();         //Fechando conexão com banco




}         /// FIM DA FUNÇÃO CHECK-IN ////



void loop() { ///////////Inicio do LOOP ////////

  // Look for new cards
  if ( ! mfrc522.PICC_IsNewCardPresent())
  {
    return;
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial())
  {
    return;
  }
  //Show UID on serial monitor
  Serial.print("UID tag :");
  String UID = "";
  for (byte i = 0; i < mfrc522.uid.size; i++)
  {
    UID.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? "0" : ""));
    UID.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  UID.toUpperCase();

  while (conn.connect(server_addr, 3306, user, password) != true) {
    delay(200);
    Serial.print ( "." );
  }
  Username = "";
  UserStatus = "";

  check(UID);


  delay(1000); //10 sec
  Serial.println();
  Serial.println("Aproxime Sua TagID");
  Serial.println();


}
