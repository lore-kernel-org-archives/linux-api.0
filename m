From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Wed, 26 Aug 2015 14:15:03 -0400
Message-ID: <55DE0227.8090905@codeaurora.org>
References: <cover.1439315079.git.somlo@cmu.edu>
	<1439977109-20314-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAKv+Gu-BOKTHb24LnemKmvCwZn0W-NOT=avY94wkkRTx2ViW=Q@mail.gmail.com>
	<20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: paul@pwsan.com, Matt Fleming <matt.fleming@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Jordan Justen <jordan.l.justen@intel.com>, "x86@kernel.org" <x86@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, gleb@cloudius-systems.com, galak@codeaurora.org, kernelnewbies@kernelnewbies.org, Gerd Hoffmann <kraxel@redhat.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, zajec5@gmail.com, linux-api@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Gabriel,

On 08/19/2015 04:49 PM, Gabriel L. Somlo wrote:
> Hi Ard,
> 
> On Wed, Aug 19, 2015 at 11:42:02AM +0200, Ard Biesheuvel wrote:
>> (missed some cc's)
>>
>> On 19 August 2015 at 11:38, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>> From: "Gabriel L. Somlo" <somlo@cmu.edu>
>>>> Several different architectures supported by QEMU are set up with a
>>>> "firmware configuration" (fw_cfg) device, used to pass configuration
>>>> "blobs" into the guest by the host running QEMU.
>>>>
>>>> Historically, these config blobs were mostly of interest to the guest
>>>> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
>>>> the command line, which makes them potentially interesting to userspace
>>>> (e.g. for passing early boot environment variables, etc.).
>>>>
>>>
>>> Does 'potentially interesting' mean you have a use case? Could you elaborate?
> 
> My personal one would be something like:
> 
> cat > guestinfo.txt << EOT
>   KEY1="val1"
>   KEY2="val2"
>   ...
> EOT
> 
> qemu-system-x86_64 ... -fw-cfg name="opt/guestinfo",file=./guestinfo.txt ...
> 
> Then, from inside the guest:
> 
>   . /sys/firmware/qemu_fw_cfg/by_name/opt/guestinfo/raw
> 
>   do_something_with $KEY1 $KEY2
>   ...
> 
> But I'm thinking this is only one of the many positive things one
> could do with the ability to access random host-supplied blobs from
> guest userspace :)

I do this with kernel parameters:

host:
qemu-system-aarch64 -append="KEY1=val1 KEY2=val2"

guest:
KEY1=`sed -nr s/.*KEY1=([^ ]+).*/\1/ /proc/cmdline`
KEY2=`sed -nr s/.*KEY2=([^ ]+).*/\1/ /proc/cmdline`

do_something_with $KEY1 $KEY2

In practice it's just script=hostfile, where hostfile is available to the
guest via a 9P passthrough filesystem mount.

While quite architecture specific, I've also previously used an
"angel-cmdline" tool for similar purposes. Peter's recent semihosting patches
support such a tool for AArch64. (On AArch32 upstream QEMU disallows
semihosting from userspace.)

Before I had 9P on all the simulators I regularly ran, I used a semihosting
based "angel-load" tool.

Regards,
Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
