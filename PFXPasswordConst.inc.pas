(* C2PP
  ***************************************************************************

  Exe Bulk Signing

  Copyright 2022-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://exebulksigning.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/ExeBulkSigning

  ***************************************************************************
  File last update : 2025-10-16T10:42:34.395+02:00
  Signature : d0be41e6541aa98aa1981a123755cf582c388e67
  ***************************************************************************
*)

// Copy this file in a _PRIVATE folder (same level than 'src' folder) if you
// want an EXE file with your password in the code and not typing it each time
// you need to sign something.
//
// select RELEASE / PRIVATERELEASE before compile and deploy

Const
  CPFXCertificate = 'MyCertificat.pfx'; // name of your certificate file
  CPFXPassword = 'MyPassword'; // password of the pfx file
