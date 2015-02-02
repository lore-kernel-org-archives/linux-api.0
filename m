From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/
 and make it readable
Date: Mon, 02 Feb 2015 09:01:14 -0500
Message-ID: <54CF832A.7010707@gmail.com>
References: <20150114153323.GF2253@moon> <20150114204653.GA26698@mail.thefacebook.com> <20150114211613.GH2253@moon> <20150122024554.GB23762@mail.thefacebook.com> <20150124031544.GA1992748@mail.thefacebook.com> <20150126124731.GA26916@node.dhcp.inet.fi> <20150126210054.GG651@moon> <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org> <20150128043832.GA2266262@mail.thefacebook.com> <CAGXu5j+wa2-CCGaktPzDec=HF0CizP__HVVjZKcjGuJJOvLFyg@mail.gmail.com> <20150131015842.GA431662@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070701070300010305000904"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150131015842.GA431662@mail.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Feiner <pfeiner@google.com>, Grant Likely <grant.likely@secretlab.ca>, Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Pavel Emelyanov <xemul@openvz.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070701070300010305000904
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-01-30 20:58, Calvin Owens wrote:
> On Thursday 01/29 at 17:30 -0800, Kees Cook wrote:
>> On Tue, Jan 27, 2015 at 8:38 PM, Calvin Owens <calvinowens@fb.com> wro=
te:
>>> On Monday 01/26 at 15:43 -0800, Andrew Morton wrote:
>>>> On Tue, 27 Jan 2015 00:00:54 +0300 Cyrill Gorcunov <gorcunov@gmail.c=
om> wrote:
>>>>
>>>>> On Mon, Jan 26, 2015 at 02:47:31PM +0200, Kirill A. Shutemov wrote:=

>>>>>> On Fri, Jan 23, 2015 at 07:15:44PM -0800, Calvin Owens wrote:
>>>>>>> Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN,=
 and
>>>>>>> is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interfa=
ce
>>>>>>> is very useful for enumerating the files mapped into a process wh=
en
>>>>>>> the more verbose information in /proc/<pid>/maps is not needed.
>>>>
>>>> This is the main (actually only) justification for the patch, and it=
 it
>>>> far too thin.  What does "not needed" mean.  Why can't people just u=
se
>>>> /proc/pid/maps?
>>>
>>> The biggest difference is that if you do something like this:
>>>
>>>          fd =3D open("/stuff", O_BLAH);
>>>          map =3D mmap(NULL, 4096, PROT_BLAH, MAP_SHARED, fd, 0);
>>>          close(fd);
>>>          unlink("/stuff");
>>>
>>> ...then map_files/ gives you a way to get a file descriptor for
>>> "/stuff", which you couldn't do with /proc/pid/maps.
>>>
>>> It's also something of a win if you just want to see what is mapped a=
t a
>>> specific address, since you can just readlink() the symlink for the
>>> address range you care about and it will go grab the appropriate VMA =
and
>>> give you the answer. /proc/pid/maps requires walking the VMA tree, wh=
ich
>>> is quite expensive for processes with many thousands of threads, even=

>>> without the O(N^2) issue.
>>>
>>> (You have to know what address range you want though, since readdir()=
 on
>>> map_files/ obviously has to walk the VMA tree just like /proc/N/maps.=
)
>>>
>>>>>>> This patch moves the folder out from behind CHECKPOINT_RESTORE, a=
nd
>>>>>>> removes the CAP_SYS_ADMIN restrictions. Following the links requi=
res
>>>>>>> the ability to ptrace the process in question, so this doesn't al=
low
>>>>>>> an attacker to do anything they couldn't already do before.
>>>>>>>
>>>>>>> Signed-off-by: Calvin Owens <calvinowens@fb.com>
>>>>>>
>>>>>> Cc +linux-api@
>>>>>
>>>>> Looks good to me, thanks! Though I would really appreciate if someo=
ne
>>>>> from security camp take a look as well.
>>>>
>>>> hm, who's that.  Kees comes to mind.
>>>>
>>>> And reviewers' task would be a heck of a lot easier if they knew wha=
t
>>>> /proc/pid/map_files actually does.  This:
>>>>
>>>> akpm3:/usr/src/25> grep -r map_files Documentation
>>>> akpm3:/usr/src/25>
>>>>
>>>> does not help.
>>>>
>>>> The 640708a2cff7f81 changelog says:
>>>>
>>>> :     This one behaves similarly to the /proc/<pid>/fd/ one - it con=
tains
>>>> :     symlinks one for each mapping with file, the name of a symlink=
 is
>>>> :     "vma->vm_start-vma->vm_end", the target is the file.  Opening =
a symlink
>>>> :     results in a file that point exactly to the same inode as them=
 vma's one.
>>>> :
>>>> :     For example the ls -l of some arbitrary /proc/<pid>/map_files/=

>>>> :
>>>> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80403000-7f8f804=
04000 -> /lib64/libc-2.5.so
>>>> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f8061e000-7f8f806=
20000 -> /lib64/libselinux.so.1
>>>> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80826000-7f8f808=
27000 -> /lib64/libacl.so.1.1.0
>>>> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a2f000-7f8f80a=
30000 -> /lib64/librt-2.5.so
>>>> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a30000-7f8f80a=
4c000 -> /lib64/ld-2.5.so
>>>>
>>>> afacit this info is also available in /proc/pid/maps, so things
>>>> shouldn't get worse if the /proc/pid/map_files permissions are at le=
ast
>>>> as restrictive as the /proc/pid/maps permissions.  Is that the case?=

>>>> (Please add to changelog).
>>>
>>> Yes, the only difference is that you can follow the link as per above=
=2E
>>> I'll resend with a new message explaining that and the deletion thing=
=2E
>>>
>>>> There's one other problem here: we're assuming that the map_files
>>>> implementation doesn't have bugs.  If it does have bugs then relaxin=
g
>>>> permissions like this will create new vulnerabilities.  And the
>>>> map_files implementation is surprisingly complex.  Is it bug-free?
>>>
>>> While I was messing with it I used it a good bit and didn't see any
>>> issues, although I didn't actively try to fuzz it or anything. I'd be=

>>> happy to write something to test hammering it in weird ways if you li=
ke.
>>> I'm also happy to write testcases for namespaces.
>>>
>>> So far as security issues, as others have pointed out you can't follo=
w
>>> the links unless you can ptrace the process in question, which seems
>>> like a pretty solid guarantee. As Cyrill pointed out in the discussio=
n
>>> about the documentation, that's the same protection as /proc/N/fd/*, =
and
>>> those links function in the same way.
>>
>> My concern here is that fd/* are connected as streams, and while that
>> has a certain level of badness as an external-to-the-process attacker,=

>> PTRACE_MODE_READ is much weaker than PTRACE_MODE_ATTACH (which is
>> required for access to /proc/N/mem). Since these fds are the things
>> mapped into memory on a process, writing to them is a subset of access=

>> to /proc/N/mem, and I don't feel that PTRACE_MODE_READ is sufficient.
>
> If you haven't done close() on a mmapped file, doesn't fd/* allow the
> same access to the corresponding regions of memory? Or am I missing
> something?
>
> But that said, I can't think of any reason making it MODE_ATTACH would
> be a problem. Would you rather that be enforced on follow_link() like
> the original patch did, or enforce it for the whole directory?
>
Whole directory would probably be better, as even just the mapped ranges =

could be considered sensitive information.  Ideally, the check should be =

done on both follow_link(), and the directory itself.



--------------ms070701070300010305000904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMjAyMTQwMTE0
WjAjBgkqhkiG9w0BCQQxFgQU4gOm3WFGTW+1qQr1WzHu3LpaBdAwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEABtXejERb1TtQEwkEaM1BZRE5zZvh
E3S3aFprchiQDlmqcjiow41vJ9WvvsXV/Rv/sLR81X0sK/ggpbh9cyuuX/YoKpRQjuxmYCsT
UsP2XplELJVTtX+zWqS9VxdcPaeUcMkKX71bSrSg1pQFpTOuPqVfibn4wYFS33YWjQ/7iMpR
42GcjJR/UIDdlid1Ui5oIwouCsFFe0LFj4iFaXYOcb0BxakpxYPr5DQxGw22FkpesjkXPKUI
vRK8n8F/vz4JqLNtkqe8MfaKHp7hFcP4rennuIArUYOroE6m1Pug2FrnI0Eoyj0OoaeNm5/5
cthkWOdibSr3KAurbK4LrR+5CQAAAAAAAA==
--------------ms070701070300010305000904--
