From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to
 dmi_decode_table
Date: Fri, 17 Apr 2015 14:40:36 +0100
Message-ID: <20150417134036.GA3671@codeblueprint.co.uk>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
 <1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
 <20150415143530.GF4804@codeblueprint.co.uk>
 <20150416103511.55927ccc@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150416103511.55927ccc@endymion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>, linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu, 16 Apr, at 10:35:11AM, Jean Delvare wrote:
> 
> I don't really care who picks these patches up and sends them to Linus,
> but I think they should all follow the same route so that Linus has as
> little merge work to do as possible. So either you pick them all, or I
> do. If I do, you'll have to drop the 2 patches you have in efi-next.
> Again I'm fine either way, so please let me know what makes your life
> easier and let's do that.

As was mentioned by Ivan, the following patches have already been merged
by Linus,

  f617b0f32da2 ("firmware: dmi_scan: Use full dmi version for SMBIOS3")
  e4b1dec448af ("firmware: dmi_scan: Use direct access to static vars")

so no patches need to be dropped from my tree and there are no pending
DMI/SMBIOS patches in any of my branches.

How about you go ahead and collect all the patches and send them to
Linus? I'm happy to pickup any patches in the future if I'm explicitly
asked, but only if OK'd by you, Jean.

Sound OK to everyone?

-- 
Matt Fleming, Intel Open Source Technology Center
