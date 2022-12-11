program FreePascalAPI;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,SQLDBLib,
  {$ENDIF}
 ctypes, SysUtils, fphttpapp, HTTPDefs, httproute, mysql57conn, SQLDB,DBLib , fpjson ,md5 , MsgBox,  jsonparser, fphttpclient   ;

var
  aData          : String;
  { Database connection types }
  aConnection    : TMySQL57Connection;
  aQuery         : TSQLQuery;
  aTransaction   : TSQLTransaction;
  { API REST variables }
  aRestRoot      : String = 'localhost';
  aRestPort      : String = ':3000';
  aRestAPI       : String = '/Api';
  aRestVersion   : String = '/v1/';
  { Configue API REST }
  aAPIurl        : String;
  aBasicUrl      : String;


function connectionMysql():String;
begin
  aConnection := TMySQL57Connection.Create(nil);
  aQuery := TSQLQuery.Create(nil);

   { DB connection Details }
  aConnection.HostName :='localhost';
  aConnection.Port :=3306;
  aConnection.UserName :='root';
  aConnection.Password :='';
  aConnection.DatabaseName :='freepacal_db';

  { DB connection Transition }
  aTransaction := TSQLTransaction.Create(aConnection);
  aConnection.Transaction := aTransaction;

  { DB connection Query start }
  aQuery.DataBase := aConnection;
  aConnection.Open();

  Result := 'Connection has been istablished !';
end;

procedure indexEndpoint (aRequest: TRequest; aResponse: TResponse);
var
  identifier : String;
begin

  try
    connectionMysql();
    identifier := aRequest.QueryFields.Values['id'] ;

     if (identifier.UpperCase()) then
     begin
            aQuery.SQL.Text :='SELECT * FROM `utilisateurs` WHERE `id`="'+aRequest.QueryFields.Values['id'] +'";';
            aQuery.Open;

            aData :=  ' [{"email" : "'+ aQuery.FieldByName('id').AsString +'","nom" : "'+ aQuery.FieldByName('prenom').AsString +'","email" : "'+ aQuery.FieldByName('mot_de_passe').AsString +'","role" : "'+ aQuery.FieldByName('profile').AsString +'","tel" : "'+ aQuery.FieldByName('tel').AsString +'" }]';

            aQuery.Close;
            { DB connection Query end }

            aResponse.Content :=aData;
            aResponse.Code :=200;
            aResponse.ContentType :='application/json';
            aResponse.ContentLength :=Length(aResponse.Content);
            aResponse.SendContent;
       end
       else
       begin
            aResponse.Content := '{"alerte":"le type d''identifiant n''est pas correcte! "}';
            aResponse.Code :=200;
            aResponse.ContentType :='application/json';
            aResponse.ContentLength :=Length(aResponse.Content);
            aResponse.SendContent;
         end;

  finally
   writeln('something went wrong !');
  end;

end;
procedure listEndpoint  (aRequest: TRequest; aResponse: TResponse);
var
  postJson,maindata: TJSONObject;
  i : Integer =0;

begin

    try
      connectionMysql();

      aQuery.SQL.Text :='SELECT * FROM `utilisateurs` ;';
      aQuery.Open;

       postJson := TJSONObject.Create;
       maindata :=TJSONObject.Create;

      while not aQuery.EOF do begin

         maindata.Add( 'id-'+IntToStr(i) , aQuery.FieldByName('id').AsString);
         maindata.Add( 'nom-'+IntToStr(i) , aQuery.FieldByName('nom').AsString);
         maindata.Add( 'prenom-'+IntToStr(i), aQuery.FieldByName('prenom').AsString);
         maindata.Add( 'email-'+IntToStr(i) , aQuery.FieldByName('email').AsString);
         maindata.Add( 'mot de passe-'+IntToStr(i) , aQuery.FieldByName('mot_de_passe').AsString);
         maindata.Add( 'role-'+IntToStr(i) , aQuery.FieldByName('role').AsString);
         maindata.Add( 'profile-'+IntToStr(i) , aQuery.FieldByName('profile').AsString) ;
         inc(i);
        aQuery.Next;
      end;
      postJson.Add(  'data' ,maindata );
      aQuery.Close;

    WriteLn('you have beeing connected successfully to the database : ');

    aResponse.Content :=   postJson.AsJSON ;
    aResponse.Code :=200;
    aResponse.ContentType :='application/json';
    aResponse.ContentLength :=Length(aResponse.Content);
    aResponse.SendContent;

    finally

    end;

end;
procedure createEndpoint(aRequest: TRequest; aResponse: TResponse);
begin
   try
     connectionMysql();

     aQuery.SQL.Text := 'INSERT INTO `utilisateurs` (`id`, `nom`, `prenom`, `email`, `tel`, `mot_de_passe`, `role`, `profile`) VALUES (NULL, '''+aRequest.QueryFields.Values['nom'] +''', '''+aRequest.QueryFields.Values['prenom'] +''', '''+aRequest.QueryFields.Values['email'] +''', '''+aRequest.QueryFields.Values['tel'] +''', '''+MD5Print(MD5File(aRequest.QueryFields.Values['mot_de_passe'])) +''', '''+aRequest.QueryFields.Values['role'] +''', '''+aRequest.QueryFields.Values['profile'] +''');' ;
     aQuery.ExecSQL();
     aTransaction.Commit();
     aQuery.Close;


    WriteLn('you have beeing connected successfully to the database : ');

    aResponse.Content := ' [{ "'+aRequest.QueryFields.Values['nom']+'" : "un nouveau element a été bien crée"}]' ;
    aResponse.Code :=200;
    aResponse.ContentType :='application/json';
    aResponse.ContentLength :=Length(aResponse.Content);
    aResponse.SendContent;

   finally
     WriteLn('something went wrong') ;
   end;

end;
procedure updateEndpoint(aRequest: TRequest; aResponse: TResponse);
 begin

  try
     connectionMysql();

     aQuery.SQL.Text := 'UPDATE `utilisateurs` SET `nom` = '''+aRequest.QueryFields.Values['nom'] +''', `prenom` = '''+aRequest.QueryFields.Values['prenom'] +''', `email` = '''+aRequest.QueryFields.Values['email'] +''', `tel` = '''+aRequest.QueryFields.Values['tel'] +''', `mot_de_passe` = '''+MD5Print(MD5File(aRequest.QueryFields.Values['mot_de_passe'])) +''', `role` = '''+aRequest.QueryFields.Values['role'] +''', `profile` = '''+aRequest.QueryFields.Values['profile'] +''' WHERE `utilisateurs`.`id` =  '+aRequest.QueryFields.Values['id'] +' ;';
     aQuery.ExecSQL();
     aTransaction.Commit();

     aQuery.Close;


    WriteLn('you have beeing connected successfully to the database : ');

    aResponse.Content := ' [{ "nom" : "un nouveau element a été bien modifié"}]' ;
    aResponse.Code :=200;
    aResponse.ContentType :='application/json';
    aResponse.ContentLength :=Length(aResponse.Content);
    aResponse.SendContent;

   finally
    WriteLn('something went wrong');
   end;

end;
procedure deleteEndpoint(aRequest: TRequest; aResponse: TResponse);
begin
  try
    { DB connection Details }
     connectionMysql();

     aQuery.SQL.Text := 'DELETE FROM `utilisateurs` WHERE `utilisateurs`.`id` ='+aRequest.QueryFields.Values['id'] +' ;' ;
     aQuery.ExecSQL();
     aTransaction.Commit();

     aQuery.Close;

     WriteLn('you have beeing connected successfully to the database : ');

    aResponse.Content := ' [{ "message" : "elemetn supprimée avec succès !"}]' ;
    aResponse.Code :=200;
    aResponse.ContentType :='application/json';
    aResponse.ContentLength :=Length(aResponse.Content);
    aResponse.SendContent;

   finally
    WriteLn('something went wrong');
   end;

end;
procedure handleEndpoint(aRequest: TRequest; aResponse: TResponse);
begin
    try
      aResponse.Content :='{ "status" : "something wrong happened during the request handling proccess."}';
      aResponse.Code :=200;
      aResponse.ContentType :='application/json';
      aResponse.ContentLength :=Length(aResponse.Content);
      aResponse.SendContent;


    finally
      WriteLn('nothing');
    end;
end;

{ Generate the routes }
function routeGen(const routeController:String):string;
begin

    aAPIurl   :=  (aRestRoot+aRestPort+aRestAPI+aRestVersion) ;
    aBasicUrl :=  (aRestAPI+aRestVersion) ;

    { ------------- Routes API --------------- }
      { Routes GET }
      HTTPRouter.RegisterRoute(Concat(aBasicUrl,routeController,'/list/all'),rmGet,@listEndpoint);
      { Routes GET }
      HTTPRouter.RegisterRoute(Concat(aBasicUrl,routeController,'/index/:id'),rmGet,@indexEndpoint);
      { Routes POST }
      HTTPRouter.RegisterRoute(Concat(aBasicUrl,routeController,'/create'),rmPost,@createEndpoint);
      { Routes PUT }
      HTTPRouter.RegisterRoute(Concat(aBasicUrl,routeController,'/update/:id'),rmPut,@updateEndpoint) ;
      { Routes DELETE }
      HTTPRouter.RegisterRoute(Concat(aBasicUrl,routeController,'/delete/:id'),rmDelete,@deleteEndpoint);
      { Error Handling }
      HTTPRouter.RegisterRoute(Concat(aBasicUrl) , rmAll, @handleEndpoint);

    { ------------- Routes API --------------- }
      WriteLn('==================== [ Endpoint : ',routeController,' ]====================');
      WriteLn('');
      WriteLn('[DELETE] ||=>', aAPIurl,routeController,'/list/all');
      WriteLn('[GET]    ||=>', aAPIurl,routeController,'/index/:id');
      WriteLn('[GET]    ||=>', aAPIurl,routeController,'/create');
      WriteLn('[ANY]    ||=>', aAPIurl,routeController,'/update/:id');
      WriteLn('[POST]   ||=>', aAPIurl,routeController,'/delete/:id');
      WriteLn('[POST]   ||=>', aAPIurl,routeController);
      WriteLn('');
      WriteLn('===============================================================');

    Result := 'Elment has ben created';

end;
{ Generate rotues listes documentation }
 { Run FreePascal Application }
function runApp(): String;
begin

    try

      { Port des routes }
      Application.Port:=3000;

      { ---------- Acivation of properties ----- }
      Application.Threaded:=True;
      Application.Initialize;

      { --------- console out put ---------- }
      WriteLn('Bienvenue sur l''API REST creer avec FreePascal :');

      // Exemple

      routeGen('user');

      Application.Run;
    finally

    end;
      Result := 'the app is wraning perfuclty';
end;
begin
  runApp();
end.

