From: hpa@zytor.com
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial ram disk
Date: Sun, 12 May 2019 03:18:16 -0700
Message-ID: <4E92753A-04BD-4018-A3A4-5E3E4242D8B9@zytor.com>
References: <20190509112420.15671-1-roberto.sassu@huawei.com> <20190512091748.s6fvy2f5p2a2o6ja@isilmar-4.linta.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190512091748.s6fvy2f5p2a2o6ja@isilmar-4.linta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, Roberto Sassu <roberto.sassu@huawei.com>
Cc: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On May 12, 2019 2:17:48 AM PDT, Dominik Brodowski <linux@dominikbrodowski=
=2Enet> wrote:
>On Thu, May 09, 2019 at 01:24:17PM +0200, Roberto Sassu wrote:
>> This proposal consists in marshaling pathnames and xattrs in a file
>called
>> =2Exattr-list=2E They are unmarshaled by the CPIO parser after all file=
s
>have
>> been extracted=2E
>
>Couldn't this parsing of the =2Exattr-list file and the setting of the
>xattrs
>be done equivalently by the initramfs' /init? Why is kernel involvement
>actually required here?
>
>Thanks,
>	Dominik

There are a lot of things that could/should be done that way=2E=2E=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
