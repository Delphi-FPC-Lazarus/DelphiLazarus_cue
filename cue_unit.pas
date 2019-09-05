{
  Einlesen von Cue Dateien
  ACHTUNG: ANSI da als Textfile gelesen

  02/2013 xe2
  02/2016 XE10 x64 Test
  xx/xxxx FPC Ubuntu

  --------------------------------------------------------------------
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  THE SOFTWARE IS PROVIDED "AS IS" AND WITHOUT WARRANTY

  Author: Peter Lorenz
  You find the code useful? Donate!
  Paypal webmaster@peter-ebe.de
  --------------------------------------------------------------------

}

{$I ..\share_settings.inc}
unit cue_unit;

interface

uses
{$IFNDEF UNIX}Windows, {$ENDIF}
{$IFDEF FPC}LCLIntf, LCLType, LMessages, {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Rcueentry = record
    title: string;
    artist: string;
    index: string;
  end;

type
  Rcue = record
    cuedatei: string;
    imgdatei: string;
    title: string;
    artist: string;
    entrys: array of Rcueentry;
  end;

function Readcue(cuedatei: string; var cue: Rcue): boolean;

implementation

// uses os_api_unit;

{$IFDEF UNIX}

const
  Delimiter = '/';
{$ELSE}

const
  Delimiter = '\';
{$ENDIF}

function Readcue(cuedatei: string; var cue: Rcue): boolean;

  function afzentf(zeile: string): string;
  begin
    Result := zeile;
    zeile := trim(zeile);
    if length(zeile) < 3 then
      exit;
    if zeile[1] = '"' then
      zeile[1] := ' ';
    if zeile[length(zeile)] = '"' then
      zeile[length(zeile)] := ' ';
    zeile := trim(zeile);
    Result := zeile;
  end;

const
  _artist: string = 'PERFORMER';
  _title: string = 'TITLE';
  _datei: string = 'FILE';
  _track: string = 'TRACK';
  _audio: string = 'AUDIO';
  _index: string = 'INDEX';
var
  f: textfile;
  s, i: integer;
  zeile, tmpstr: string;
  txt: boolean;
  parts: array of string;
begin
  Readcue := false;

  { preset }
  cue.cuedatei := cuedatei;
  cue.imgdatei := '';
  cue.title := '';
  cue.artist := '';
  setlength(cue.entrys, 0);

  if not fileexists(cuedatei) then
    exit;

  try
    assignfile(f, cue.cuedatei);
    reset(f);
    s := 0;
    zeile := '';
    repeat
      readln(f, zeile);
      zeile := trim(zeile);
      if length(zeile) > 0 then
      begin
        { zeile aufsplitten }
        setlength(parts, 0);
        tmpstr := '';
        zeile := zeile + ' '; { damit letzter eintrag berücksichtigt }
        txt := false;
        for i := 1 to length(zeile) do
        begin
          if zeile[i] = '"' then
            txt := not txt;
          if (zeile[i] = ' ') and (txt = false) then
          begin
            setlength(parts, high(parts) + 1 + 1);
            parts[high(parts)] := tmpstr;
            tmpstr := '';
          end
          else
            tmpstr := tmpstr + zeile[i];
        end; { next i }

        { auswerten }
        if high(parts) > -1 then
        begin
          { nächsten track erkennen }
          if high(parts) >= 2 then
            if (uppercase(trim(parts[0])) = _track) and
              (uppercase(trim(parts[2])) = _audio) then
            begin
              setlength(cue.entrys, high(cue.entrys) + 1 + 1);
              cue.entrys[high(cue.entrys)].title := '';
              cue.entrys[high(cue.entrys)].artist := '';
              cue.entrys[high(cue.entrys)].index := '';
              inc(s);
            end;

          { hauptinformationen }
          if s = 0 then
          begin
            { allg. }
            if (uppercase(trim(parts[0])) = _artist) and (high(parts) >= 1) then
              cue.artist := afzentf(parts[1]);
            if (uppercase(trim(parts[0])) = _title) and (high(parts) >= 1) then
              cue.title := afzentf(parts[1]);
            if (uppercase(trim(parts[0])) = _datei) and (high(parts) >= 1) then
              cue.imgdatei := afzentf(parts[1]);
          end;

          { trackinformationen }
          if s > 0 then
          begin
            if (uppercase(trim(parts[0])) = _artist) and (high(parts) >= 1) then
              cue.entrys[high(cue.entrys)].artist := afzentf(parts[1]);
            if (uppercase(trim(parts[0])) = _title) and (high(parts) >= 1) then
              cue.entrys[high(cue.entrys)].title := afzentf(parts[1]);
            if (uppercase(trim(parts[0])) = _index) and (high(parts) >= 2) then
              cue.entrys[high(cue.entrys)].index := afzentf(parts[2]);
          end;
        end; { of high(parts) > 0 }
      end; { of length(zeile) > 0 }
    until eof(f);

    { ggf. pfad hinzufügen }
    if (strrscan(pchar(cue.imgdatei), Delimiter) = nil) then
    begin
      tmpstr := IncludeTrailingPathDelimiter(extractfilepath(cue.cuedatei));
      cue.imgdatei := tmpstr + cue.imgdatei;
    end;

    if (high(cue.entrys) > -1) then
      Readcue := true;
  except
    on e: exception do
    begin
      { nix, hat halt net geklappt }
    end;
  end;

  try
    closefile(f);
  except
    on e: exception do
    begin
      { nix, hat halt net geklappt }
    end;
  end;

end;

end.
