From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: livepatch: old_name@old_addr scheme in livepatch sysfs directory
Date: Sat, 31 Oct 2015 23:01:40 -0500
Message-ID: <56358EA4.10900@canonical.com>
References: <1446263060-22175-1-git-send-email-chris.j.arges@canonical.com>
 <20151101015258.GA8199@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151101015258.GA8199@packer-debian-8-amd64.digitalocean.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/31/2015 08:53 PM, Jessica Yu wrote:
> +++ Chris J Arges [30/10/15 22:44 -0500]:
>> The following directory structure will allow for cases when the same
>> function name exists in a single object.
>>     /sys/kernel/livepatch/<patch>/<object>/<function@address>
> 
> Hi Chris, thanks for the patch.
> 
> I think the last time this issue was discussed, the conclusion was
> that concatenating the address to the function name constitutes as an
> information leak (as the sysfs entry is visible to non-root users).
> 
> One option suggested by Josh in that thread would be to do something
> like "func.n", where n is just the nth occurrence of the symbol name.
> Another option might be to keep the func@addr format but not make these
> entries visible to non-root users.
> 
> Jessica
> 

Jessica,

Makes sense to me. Is there a reason why the sysfs entries are visible
to non-root users?

Otherwise, if there is a use-case for keeping the permissions the same,
then I'd be happy to to use the 'func.n' format for v2.

--chris
