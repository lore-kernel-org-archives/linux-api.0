From: hpa@zytor.com
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial ram disk
Date: Sun, 12 May 2019 17:23:16 -0700
Message-ID: <0D08BE40-475A-47AB-A3CE-B8EC4C4357D9@zytor.com>
References: <20190512153105.GA25254@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190512153105.GA25254@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On May 12, 2019 8:31:05 AM PDT, Dominik Brodowski <linux@dominikbrodowski=
=2Enet> wrote:
>On Sun, May 12, 2019 at 03:18:16AM -0700, hpa@zytor=2Ecom wrote:
>> > Couldn't this parsing of the =2Exattr-list file and the setting of
>the xattrs
>> > be done equivalently by the initramfs' /init? Why is kernel
>involvement
>> > actually required here?
>>=20
>> There are a lot of things that could/should be done that way=2E=2E=2E
>
>Indeed=2E=2E=2E so why not try to avoid adding more such "things", and
>keeping
>them in userspace (or in a fork_usermode_blob)?
>
>
>On Sun, May 12, 2019 at 08:52:47AM -0400, Mimi Zohar wrote:
>> It's too late=2E  The /init itself should be signed and verified=2E
>
>Could you elaborate a bit more about the threat model, and why
>deferring
>this to the initramfs is too late?
>
>Thanks,
>	Dominik

I tried over 10 years ago to make exactly that happen=2E=2E=2E it was call=
ed the klibc project=2E Linus turned it down because he felt that it didn't=
 provide enough immediate benefit to justify the complexity, which of cours=
e creates the thousand-cuts problem: there will never be *one single* event=
 that *by itself* justifies the transition=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
