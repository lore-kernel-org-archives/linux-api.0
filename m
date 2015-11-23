From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 3/3 v8] livepatch: function,sympos scheme in livepatch
 sysfs directory
Date: Mon, 23 Nov 2015 10:47:51 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511231047400.30177@pobox.suse.cz>
References: <1447693391-10065-1-git-send-email-chris.j.arges@canonical.com> <1448040325-32498-1-git-send-email-chris.j.arges@canonical.com> <1448040325-32498-4-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448040325-32498-4-git-send-email-chris.j.arges@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com, jeyu@redhat.com, Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 20 Nov 2015, Chris J Arges wrote:

> The following directory structure will allow for cases when the same
> function name exists in a single object.
> 	/sys/kernel/livepatch/<patch>/<object>/<function,sympos>
> 
> The sympos number corresponds to the nth occurrence of the symbol name in
> kallsyms for the patched object.
> 
> An example of patching multiple symbols can be found here:
> 	https://github.com/dynup/kpatch/issues/493
> 
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

Miroslav
