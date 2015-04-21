From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [Patch v2 2/3] firmware: dmi_scan: add SBMIOS entry
 and DMI tables
Date: Tue, 21 Apr 2015 17:36:13 +0200
Message-ID: <20150421173613.6601da15@endymion.delvare>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1429525187-3376-3-git-send-email-ivan.khoronzhuk@globallogic.com>
Reply-To: dmidecode-devel@nongnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org>
In-Reply-To: <1429525187-3376-3-git-send-email-ivan.khoronzhuk@globallogic.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/dmidecode-devel>,
	<mailto:dmidecode-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/dmidecode-devel>
List-Post: <mailto:dmidecode-devel@nongnu.org>
List-Help: <mailto:dmidecode-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/dmidecode-devel>,
	<mailto:dmidecode-devel-request@nongnu.org?subject=subscribe>
Errors-To: dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org
Sender: dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org
To: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
Cc: dmidecode-devel@nongnu.org, matt.fleming@intel.com, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, mikew@google.com, roy.franz@linaro.org, msalter@redhat.com, grant.likely@linaro.org
List-Id: linux-api@vger.kernel.org

Hi again Ivan,

On Mon, 20 Apr 2015 13:19:46 +0300, Ivan Khoronzhuk wrote:
> +	bin_attr_DMI.size = dmi_len;
> +	bin_attr_DMI.private = dmi_table;
> +	ret = sysfs_create_bin_file(tables_kobj, &bin_attr_DMI);
> +	if (!ret)
> +		return 0;

I just found that more work is needed here for the SMBIOS v3 entry
point case. These entry points do not specify the exact length of the
table, but only its maximum. The real world sample I have access to
indeed specifies a maximum length of 6419 bytes, but the actual table
only spans over 2373 bytes. It is properly terminated with a type 127
DMI structure, so the kernel table parser ignores the garbage after it.
The garbage is however exported to user-space above.

I taught dmidecode to ignore the garbage, but there are two problem
left here. First problem is a waste of memory. Minor issue I suppose,
who cares about a few kilobytes these days.

Second problem is a security problem. We are leaking the contents of
physical memory to user-space. In my case it's filled with 0xffs so no
big deal. But what if actual data happens to be stored there? It
definitely shouldn't go to user-space.

So dmi_len needs to be trimmed to the actual table size before the
attribute above is created. I have an idea how this could be
implemented easily, let me give it a try.

Maybe we should trim the length for previous implementations, too.
There is no reason to walk past a type 127 structure anyway, ever.

-- 
Jean Delvare
SUSE L3 Support
