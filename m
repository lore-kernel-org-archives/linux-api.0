From: =?UTF-8?Q?Fran=c3=a7ois_Revol?= <revol@free.fr>
Subject: Re: [PATCH v4 4/4] devicetree: update documentation
 for fw_cfg ARM bindings
Date: Wed, 18 Nov 2015 14:04:24 +0100
Message-ID: <564C7758.6010103@free.fr>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
	<1447470235-13643-5-git-send-email-somlo@cmu.edu>
	<20151115020754.GA21323@rob-hp-laptop> <564995FA.40308@redhat.com>
	<CAL_JsqKEi9BozyLQ9sKM3VL-hSSRntDyET859N1qTTMT4jkDOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <CAL_JsqKEi9BozyLQ9sKM3VL-hSSRntDyET859N1qTTMT4jkDOw@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Rob Herring <robh@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, mst@redhat.com, stefanha@gmail.com, QEMU Developers <qemu-devel@nongnu.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>, kraxel@redhat.com, Pawel Moll <pawel.moll@arm.com>, kernelnewbies@kernelnewbies.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Laszlo Ersek <lersek@redhat.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ijc+devicetree@hellion.org.uk>, jordan.l.justen@intel.com, "Gabriel L. Somlo" <somlo@cmu.edu>, Kumar Gala <galak@codeaurora.org>, Leif Lindholm <leif.lindholm@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, "matt.fleming@intel.com" <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>lin
List-Id: linux-api@vger.kernel.org

On 17/11/2015 23:14, Rob Herring wrote:
> On Mon, Nov 16, 2015 at 2:38 AM, Paolo Bonzini <pbonzini@redhat.com> wr=
ote:
>>
>>
>> On 15/11/2015 03:07, Rob Herring wrote:
>>> We generally don't want DT docs to depend on other kernel documentati=
on.
>>
>> DT docs do not contain a copy of the data sheets, either.  There is no
>> reason to say how to use the device (and even then, only doing so
>> partially) in the DT docs.
>=20
> The difference is datasheets apply to all OS's, kernel documentation
> does not. In theory at least this could be used for other OS's, right?

Would be nice indeed, as it's part of their intended purpose.

For now we have to shoehorn things into linux-only stuff (like initrd)
because well, nobody cares enough about NetBSD to compile U-Boot with
its internal API, so let alone adding custom Haiku code.

And of course, for things linux doesn't care about (like framebuffer
description) then we're stuck trying to guess where it's at and writing
drivers for our bootloader.

So if at least people were considering they aren't the only users of
this, that'd make life better for everyone.

> Perhaps QEMU is the right place to thoroughly describe this and DT and
> sysfs docs can refer to it.

The brilliant idea of FDT was that we could have a canonical source and
blob for it where people could send patches, but of course Linux and BSD
freaks disagreed, so you now find Linux-flavoured DTs for rPi and other
things, as well as BSD versions.

Please, at least get the binding documentation for this unique and
usable for everyone!

Fran=E7ois.
