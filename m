From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [Patch 1/3] firmware: dmi_scan: rename dmi_table to
 dmi_decode_table
Date: Wed, 15 Apr 2015 13:51:12 +0200
Message-ID: <20150415135112.494d14f9@endymion.delvare>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu,  2 Apr 2015 15:57:01 +0300, Ivan Khoronzhuk wrote:
> The "dmi_table" function looks like data instance, but it does DMI
> table decode. This patch renames it to "dmi_decode_table" name as
> more appropriate. That allows us to use "dmi_table" name for correct
> purposes.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
> ---
>  drivers/firmware/dmi_scan.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> (...)

Yes, as discussed before, good idea.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
