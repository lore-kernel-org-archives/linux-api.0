From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 0/4] SysFS driver for QEMU fw_cfg device
Date: Sat, 19 Dec 2015 10:12:28 +0100
Message-ID: <20151219091228.GA6024@amd>
References: <1449242946-12062-1-git-send-email-somlo@cmu.edu>
 <20151217160923.GI19448@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151217160923.GI19448@HEDWIG.INI.CMU.EDU>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, qemu-devel@nongnu.org, jordan.l.justen@intel.com, mst@redhat.com, peter.maydell@linaro.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com, kraxel@redhat.com, luto@amacapital.net, stefanha@gmail.com, revol@free.fr, matt@codeblueprint.co.uk
List-Id: linux-api@vger.kernel.org

Hi!

On Thu 2015-12-17 11:09:23, Gabriel L. Somlo wrote:
> ping ?
> 
> Also, for the corresponding patch set on the QEMU end of things,
> ping on http://thread.gmane.org/gmane.comp.emulators.qemu/376321

I guess missing information is why such access is a good
idea. Debugging?

								Pavel

> On Fri, Dec 04, 2015 at 10:29:02AM -0500, Gabriel L. Somlo wrote:
> > Allow access to QEMU firmware blobs, passed into the guest VM via
> > the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
> > size, and fw_cfg key), as well as the raw binary blob data may be
> > accessed.
> > 
> > The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
> > selected based on overall similarity to the type of information
> > exposed under /sys/firmware/dmi/entries/...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
