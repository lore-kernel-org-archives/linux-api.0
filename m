From: Jethro Beekman <jethro@fortanix.com>
Subject: Re: RFC: userspace exception fixups
Date: Wed, 21 Nov 2018 05:17:32 +0000
Message-ID: <0a78772e-4f42-254b-d91a-f0f80a24ff90@fortanix.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
 <20181120101133.GA7319@linux.intel.com>
 <CALCETrU2dy7Oh+AHDGZ2omq9p7pNbjFd8ruv5CkfJXCp5nTYBQ@mail.gmail.com>
 <20181120225518.GE8391@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000004040406070609060704"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120225518.GE8391@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, "nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutroni>
List-Id: linux-api@vger.kernel.org

--------------ms000004040406070609060704
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-21 04:25, Jarkko Sakkinen wrote:
> On Tue, Nov 20, 2018 at 07:19:37AM -0800, Andy Lutomirski wrote:
>> general by mucking with some regs and retrying -- that will infinite
>> loop and confuse everyone.  I'm not even 100% convinced that decoding
>> the insn stream is useful -- AEP can point to something that isn't
>> ENCLU.
>=20
> In my return-to-AEP approach to whole point was not to do any decoding
> but instead have something else always in the AEP handler than just
> ENCLU.
>=20
> No instruction decoding. No RIP manipulation.
>=20
>> IOW the kernel needs to know *when* to apply this special behavior.
>> Sadly there is no bit in the exception frame that says "came from
>> SGX".

Jarkko, can you please explain you solution in detail? The CPU receives=20
an exception. This will be handled by the kernel exception handler. What =

information does the kernel exception handler use to determine whether=20
to deliver the exception as a regular signal to the process, or whether=20
to set the special registers values for userspace and just continue=20
executing the process manually?

--
Jethro Beekman | Fortanix


--------------ms000004040406070609060704
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
Cx8wggUxMIIEGaADAgECAhBdZC9mIseKJlmxx1xn+g00MA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xODA5MTUwMDAw
MDBaFw0xOTA5MTUyMzU5NTlaMCQxIjAgBgkqhkiG9w0BCQEWE2pldGhyb0Bmb3J0YW5peC5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDRQDOQsroKjy2xAQCXLyqryJt4
Xwj8hcweJCzOnjILKHIoWlOQ0b9yIbFLIWBRt/9zdxlE5ZabDVHnkIyhcVgtU/BA73e78Wx2
LOObdg0wfs9U2CVRYhz2EPHFjGvkYKihItt69ye91hj1w7RKCrYC8KZGSZ/+sbkJzQdXVy32
lxmiNEt17GNRebpkJCaFnznd6C2a8tBAS2Fa/UNyFdEs4eoRoYSKswclRhbe81aVhqY2hjcd
O6puyyaYp5hkmau2UPih6OpRSOhbe6Tuebceg1yvumoVX3OZtGPS1VdQ+p0bxB0RE6gNs140
ZKUhrvAJDETuGaaQD4A2/6ksLunjAgMBAAGjggHpMIIB5TAfBgNVHSMEGDAWgBSCr2yM+MX+
lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUsFUcmGtaJBU7/52LyTYHC/M+LscwDgYDVR0PAQH/
BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsG
AQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBL
hklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0
dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5k
U2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTAeBgNVHREEFzAVgRNqZXRocm9AZm9ydGFuaXguY29tMA0GCSqGSIb3DQEBCwUAA4IBAQB6
v3tFEUSGv9+yY4wUjvcMyz3126nJrX5LkfEvrnCEpEiImECuoYvxOYNLYYynell7BQGtTaZg
shMfDvwpy2isoi3w1AWAfbn6npnSKLzu0BMRvcCPWY8VPmePPizTqXoPkLwgTJfSaWkxMP1u
rfL9S5NeRdkjwjHklX5IWuwwDu1hsKVZrxSSY2unCtvq67UHWz+z6rG1JQrP2YDfb98xun3y
eLBNe/LFBNnGISbkT5q6D+e5c0bgzoH9nH4bsw3t8aDqJTfT3BqQdWr4pF05ODzzeOmEqeYE
qGlD9hIL2AbmTZLjunAnARr6Fv7Sfqt23ptsGkmoZ9ZQNjT3TlwvMIIF5jCCA86gAwIBAgIQ
apvhODv/K2ufAdXZuKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNV
BAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09N
T0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR22YRq2tA9
NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWlVJGyK+Ul
NEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqOtzk06kb2
qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg2hJZ
jrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGj
ggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9s
jPjF/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
EQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2Rv
Y2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEB
BGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRk
VHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkq
hkiG9w0BAQwFAAOCAgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+js
QgwRGiHjZrAYayZrrm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD
7f3iT7PdkHJY9B51csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO
+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6
E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyvB8czm12F
gX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP0PRLRTiO
SEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1Enk8MQkz
/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVifC3HtwlSa
m9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnHn9tFpMpO
UvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIEMQIBATCB
rDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yi
x4omWbHHXGf6DTQwDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEyMTA1MTcxNFowLwYJKoZIhvcNAQkEMSIEIGkGlOHK
cYyCgXgQqe9tx5ygCjVEV/nvbsGrC5dTsC2XMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQA1mRKY4bQ5D4GZp6TvTQ5T/mFnJBANLpt0ijL0aBAYRtdOtslp5MLQ6fWkUi/v7jE4gRq/
2CPeEz/hH5cuCSiV6CWGwce26smT143VFewwTYb3xvFdYHV3umDwokM273LQN2cWQHmoFzFe
io6zK/JIJW/7Jp1vXeP4xzFdyy+2EMg4PN0g7rcL8xbR0AIMFbvOYpNUVo6GRJxCBUN8pvjm
DQuMMJyTAA3viBdq6HHrThpL2kpB/yceqAY2cUE7r7wkNwbx4id9C2JF6xMnevm0wb1U4M89
W1Dp7xB02e4No9sAaHg5+jtuBwgP+9tJcBUDiiSBBeYAu6eBtBSlfkheAAAAAAAA

--------------ms000004040406070609060704--
