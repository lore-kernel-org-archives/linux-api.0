Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC9CC433E0
	for <linux-api@archiver.kernel.org>; Sat,  6 Feb 2021 17:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA5EB64E2F
	for <linux-api@archiver.kernel.org>; Sat,  6 Feb 2021 17:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhBFR5s (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 6 Feb 2021 12:57:48 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:47152 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230251AbhBFR5r (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 6 Feb 2021 12:57:47 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 225168384365;
        Sat,  6 Feb 2021 17:57:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: power55_5f041ec275ef
X-Filterd-Recvd-Size: 3908
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Sat,  6 Feb 2021 17:57:01 +0000 (UTC)
Message-ID: <49124db60cdc88c4e9fcca1bbc9767432ad5a93b.camel@perches.com>
Subject: Re: [PATCH] printk: Userspace format enumeration support
From:   Joe Perches <joe@perches.com>
To:     Chris Down <chris@chrisdown.name>, Petr Mladek <pmladek@suse.com>
Cc:     linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        John Ogness <john.ogness@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org
Date:   Sat, 06 Feb 2021 09:57:00 -0800
In-Reply-To: <YB3Fwh827m0F+y3n@chrisdown.name>
References: <YBwU0G+P0vb9wTwm@chrisdown.name> <YB11jybvFCb95S9e@alley>
         <YB3Fwh827m0F+y3n@chrisdown.name>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, 2021-02-05 at 22:25 +0000, Chris Down wrote:
> Petr Mladek writes:
> >   + <module> is already optinaly added by pr_fmt() to the printed strings
> >     as:  pr_fmt(): ...
> 
> pr_fmts are not consistently used across the kernel, and sometimes differ from 
> the module itself. Many modules don't use it at all, and we also don't have it 
> for pr_cont. Just picking some random examples:
> 
>      % grep -av vmlinux /proc/printk_formats | shuf -n 10
>      mac80211,6%s: mesh STA %pM switches to channel requiring DFS (%d MHz, width:%d, CF1/2: %d/%d MHz), aborting
>      thinkpad_acpi,c N/Athinkpad_acpi,c %dthinkpad_acpi,5thinkpad_acpi: temperatures (Celsius):thinkpad_acpi,3thinkpad_acpi: Out of memory for LED data

I don't understand this format.

"Out of memory for LED data" is a single printk ending with a '\n' newline 
I expected this to be broken up into multiple lines, one for each printk
that endsd in a newline.

And what would happen if the function was refactored removing the pr_cont
uses like the below: (basically, any output that uses a mechanism that
aggregates a buffer then emits it, and there are a _lot_ of those)

	printk("%s\n", buffer);

And there is already a relatively trivial way to do this using a modified
version of strings that looks for KERN_SOH[0-6], and if dynamic_debug is
enabled, look in the dynamic_debug section, either __verbose or __dyndbg
depending on the kernel version.

---
 drivers/platform/x86/thinkpad_acpi.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 18b390153e7f..ff1c09c600f8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6353,21 +6353,26 @@ static void thermal_dump_all_sensors(void)
 {
 	int n, i;
 	struct ibm_thermal_sensors_struct t;
+	char output[256];
+	int len = 0;
 
 	n = thermal_get_sensors(&t);
 	if (n <= 0)
 		return;
 
-	pr_notice("temperatures (Celsius):");
+	len += scnprintf(output + len, sizeof(output) - len,
+		       "temperatures (Celsius):");
 
 	for (i = 0; i < n; i++) {
-		if (t.temp[i] != TPACPI_THERMAL_SENSOR_NA)
-			pr_cont(" %d", (int)(t.temp[i] / 1000));
+		if (t.temp[i] == TPACPI_THERMAL_SENSOR_NA)
+			len += scnprintf(output + len, sizeof(output) - len,
+					 " N/A");
 		else
-			pr_cont(" N/A");
+			len += scnprintf(output + len, sizeof(output) - len,
+					 " %d", t.temp[i] / 1000);
 	}
 
-	pr_cont("\n");
+	pr_notice("%s\n", output);
 }
 
 /* sysfs temp##_input -------------------------------------------------- */

