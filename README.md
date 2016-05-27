# azcopy-cookbook

Provides a Chef Lightweight Resource Provider (LWRP) for Azure Copy tool.

## Supported Platforms

Windows 2008R2
Windows 2012
Windows 2012R2

## Attributes

WIP

<table>
  <tr>
    <th>Action</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>:download</td>
    <td>Downloads a file and replaces existing file</td>
  </tr>
  <tr>
    <td>:download_if_missing</td>
    <td>Downloads a file only if missing</td>
  </tr>

</table>
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>key</tt></td>
    <td>String</td>
    <td>Azure blob storage Key</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>blob</tt></td>
    <td>String</td>
    <td>FQDN of the Azure Blob to access</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>folder</tt></td>
    <td>String</td>
    <td>Subfolder within the Blob to access</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>file</tt></td>
    <td>Array</td>
    <td>An array of strings or hashes of files to download and/or rename</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>destination</tt></td>
    <td>String</td>
    <td>Local destination to download files. (Does not apply to uploads)</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>ignore_journal</tt></td>
    <td>Boolean</td>
    <td>Ignore the Azure journal files, and force a download.</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### azcopy::default

TO DO

## License and Authors

Author:: Amitraj Budhu (<abudhu@gmail.com>)
