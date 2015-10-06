From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 1/4] firmware: introduce sysfs driver for QEMU's fw_cfg device
Date: Tue, 6 Oct 2015 10:54:42 -0700
Message-ID: <CALCETrXdTf-85zzGYN28iGhcUMwE-h0o_GQ1XSFK-6q0AZNvgw@mail.gmail.com>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu> <1443914889-9619-2-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443914889-9619-2-git-send-email-somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, paul@pwsan.com, galak@codeaurora.org, Will Deacon <will.deacon@arm.com>, agross@codeaurora.org, Mark Rutland <mark.rutland@arm.com>, zajec5@gmail.com, hanjun.guo@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernelnewbies@kernelnewbies.org, Matt Fleming <matt.fleming@intel.com>, Laszlo Ersek <lersek@redhat.com>, "Jordan Justen (Intel address)" <jordan.l.justen@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, peter.maydell@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, kraxel@redhat.com, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 3, 2015 at 4:28 PM, Gabriel L. Somlo <somlo@cmu.edu> wrote:
> From: Gabriel Somlo <somlo@cmu.edu>
>
> Make fw_cfg entries of type "file" available via sysfs. Entries
> are listed under /sys/firmware/qemu_fw_cfg/by_key, in folders
> named after each entry's selector key. Filename, selector value,
> and size read-only attributes are included for each entry. Also,
> a "raw" attribute allows retrieval of the full binary content of
> each entry.
>
> This patch also provides a documentation file outlining the
> guest-side "hardware" interface exposed by the QEMU fw_cfg device.
>

What's the status of "by_name"?  There's a single (presumably
incorrect) mention of it in a comment in this patch.

I would prefer if the kernel populated by_name itself rather than
deferring that to udev, since I'd like to use this facility in virtme,
and I'd like to use fw_cfg very early on boot before I even start
udev.

--Andy
