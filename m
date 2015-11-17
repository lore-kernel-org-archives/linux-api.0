From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 4/4] devicetree: update documentation
 for fw_cfg ARM bindings
Date: Tue, 17 Nov 2015 16:14:42 -0600
Message-ID: <CAL_JsqKEi9BozyLQ9sKM3VL-hSSRntDyET859N1qTTMT4jkDOw@mail.gmail.com>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
	<1447470235-13643-5-git-send-email-somlo@cmu.edu>
	<20151115020754.GA21323@rob-hp-laptop> <564995FA.40308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <564995FA.40308@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, mst@redhat.com, stefanha@gmail.com, QEMU Developers <qemu-devel@nongnu.org>, Eric Anholt <eric@anholt.net>, kraxel@redhat.com, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Andy Gross <agross@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>, kernelnewbies@kernelnewbies.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Laszlo Ersek <lersek@redhat.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ijc+devicetree@hellion.org.uk>, jordan.l.justen@intel.com, "Gabriel L. Somlo" <somlo@cmu.edu>, Kumar Gala <galak@codeaurora.org>, Leif Lindholm <leif.lindholm@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg
List-Id: linux-api@vger.kernel.org

On Mon, Nov 16, 2015 at 2:38 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 15/11/2015 03:07, Rob Herring wrote:
>> We generally don't want DT docs to depend on other kernel documentation.
>
> DT docs do not contain a copy of the data sheets, either.  There is no
> reason to say how to use the device (and even then, only doing so
> partially) in the DT docs.

The difference is datasheets apply to all OS's, kernel documentation
does not. In theory at least this could be used for other OS's, right?

Perhaps QEMU is the right place to thoroughly describe this and DT and
sysfs docs can refer to it.

Rob
