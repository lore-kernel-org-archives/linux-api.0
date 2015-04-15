From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [Patch 3/3] Documentation: ABI: sysfs-firmware-dmi: add
 -entries suffix to file name
Date: Wed, 15 Apr 2015 13:52:20 +0200
Message-ID: <20150415135220.1a9b9fe5@endymion.delvare>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-4-git-send-email-ivan.khoronzhuk@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1427979423-22767-4-git-send-email-ivan.khoronzhuk@globallogic.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org

Hi Ivan,

On Thu,  2 Apr 2015 15:57:03 +0300, Ivan Khoronzhuk wrote:
> The dmi-sysfs module adds DMI table structures entries under
> /sys/firmware/dmi/entries only, so rename documentation file to
> sysfs-firmware-dmi-entries as more appropriate. Without renaming it's
> confusing to differ this from sysfs-firmware-dmi-tables that adds raw
> DMI table and actually adds "dmi" kobject.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
> ---
>  .../ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries}      | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  rename Documentation/ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries} (99%)
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
> similarity index 99%
> rename from Documentation/ABI/testing/sysfs-firmware-dmi
> rename to Documentation/ABI/testing/sysfs-firmware-dmi-entries
> index c78f9ab..210ad44 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-dmi
> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
> @@ -1,4 +1,4 @@
> -What:		/sys/firmware/dmi/
> +What:		/sys/firmware/dmi/entries/
>  Date:		February 2011
>  Contact:	Mike Waychison <mikew@google.com>
>  Description:

Thanks for doing this.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
