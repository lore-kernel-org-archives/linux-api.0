From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [Qemu-devel] [PATCH v3 1/4] firmware: introduce sysfs driver for
 QEMU's fw_cfg device
Date: Tue, 6 Oct 2015 09:40:42 +0100
Message-ID: <20151006084042.GC19089@stefanha-thinkpad>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <1443914889-9619-2-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443914889-9619-2-git-send-email-somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: gregkh@linuxfoundation.org, paul@pwsan.com, galak@codeaurora.org, will.deacon@arm.com, agross@codeaurora.org, mark.rutland@arm.com, zajec5@gmail.com, hanjun.guo@linaro.org, catalin.marinas@arm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, peter.maydell@linaro.org, matt.fleming@intel.com, mst@redhat.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, qemu-devel@nongnu.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, kraxel@redhat.com, pbonzini@redhat.com, lersek@redhat.com
List-Id: linux-api@vger.kernel.org

On Sat, Oct 03, 2015 at 07:28:06PM -0400, Gabriel L. Somlo wrote:
> +/* read chunk of given fw_cfg blob (caller responsible for sanity-check) */
> +static inline void fw_cfg_read_blob(u16 key,
> +				    void *buf, loff_t pos, size_t count)
> +{
> +	mutex_lock(&fw_cfg_dev_lock);
> +	iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
> +	while (pos-- > 0)
> +		ioread8(fw_cfg_reg_data);
> +	ioread8_rep(fw_cfg_reg_data, buf, count);
> +	mutex_unlock(&fw_cfg_dev_lock);
> +}

Have you had a chance to play with Marc Mari's fw_cfg DMA interface
patches?  They should make this operation much faster.

https://www.mail-archive.com/qemu-devel@nongnu.org/msg325541.html

Stefan
