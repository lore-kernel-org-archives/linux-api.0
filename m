From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to
 dmi_decode_table
Date: Wed, 15 Apr 2015 15:35:30 +0100
Message-ID: <20150415143530.GF4804@codeblueprint.co.uk>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
 <1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427979423-22767-2-git-send-email-ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jdelvare-l3A5Bk7waGM@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 02 Apr, at 03:57:01PM, Ivan Khoronzhuk wrote:
> The "dmi_table" function looks like data instance, but it does DMI
> table decode. This patch renames it to "dmi_decode_table" name as
> more appropriate. That allows us to use "dmi_table" name for correct
> purposes.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
> ---
>  drivers/firmware/dmi_scan.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Looks good to me.

Jean, do you want me to pick this patch up or are you going to?

-- 
Matt Fleming, Intel Open Source Technology Center
