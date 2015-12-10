From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Thu, 10 Dec 2015 08:38:17 -0600
Message-ID: <20151210143817.GB29872@treble.redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-3-git-send-email-jeyu@redhat.com>
 <20151208183212.GB14846@treble.redhat.com>
 <20151209200523.GB25387@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151209200523.GB25387@packer-debian-8-amd64.digitalocean.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 09, 2015 at 03:05:23PM -0500, Jessica Yu wrote:
> +++ Josh Poimboeuf [08/12/15 12:32 -0600]:
> >On Mon, Nov 30, 2015 at 11:21:15PM -0500, Jessica Yu wrote:
> >>For livepatch modules, copy Elf section, symbol, and string information
> >>from the load_info struct in the module loader.
> >>
> >>Livepatch uses special relocation sections in order to be able to patch
> >>modules that are not yet loaded, as well as apply patches to the kernel
> >>when the addresses of symbols cannot be determined at compile time (for
> >>example, when kaslr is enabled). Livepatch modules must preserve Elf
> >>information such as section indices in order to apply the remaining
> >>relocation sections at the appropriate time (i.e. when the target module
> >>loads).
> >>
> >>Signed-off-by: Jessica Yu <jeyu@redhat.com>
> >>---
> >> include/linux/module.h |  9 +++++
> >> kernel/module.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >> 2 files changed, 105 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/include/linux/module.h b/include/linux/module.h
> >>index 3a19c79..9b46256 100644
> >>--- a/include/linux/module.h
> >>+++ b/include/linux/module.h
> >>@@ -425,6 +425,14 @@ struct module {
> >>
> >> 	/* Notes attributes */
> >> 	struct module_notes_attrs *notes_attrs;
> >>+
> >>+	/* Elf information (optionally saved) */
> >>+	Elf_Ehdr *hdr;
> >
> >I would rename "hdr" to "elf_hdr" to make its purpose clearer.
> >
> >>+	Elf_Shdr *sechdrs;
> >>+	char *secstrings;
> >
> >Probably a good idea to add underscores to the names ("sec_hdrs" and
> >"sec_strings") to be consistent with most of the other fields in the
> >struct.
> >
> >>+	struct {
> >>+		unsigned int sym, str, mod, vers, info, pcpu;
> >>+	} index;
> >
> >I might be contradicting myself from what I said before.  But I'm
> >thinking we should put all these fields inside a CONFIG_LIVEPATCH ifdef.
> >Then below, there could be two versions of copy_module_elf(), the real
> >one for LIVEPATCH and and an empty one for !LIVEPATCH.  And the same
> >story for free_module_elf().
> 
> I think in the v1 discussion we were leaning more towards making this
> generic. We could potentially just have the Elf module fields
> available in the generic case, independent of whether CONFIG_LIVEPATCH
> is set, whereas the mod->klp field should probably be only available
> when LIVEPATCH is set. I think this makes sense since the Elf fields
> aren't dependent on livepatch (although livepatch would be the only
> user of these fields at the moment). I don't know if there would be
> any users in the future that would be interested in using this Elf
> information. Thoughts on this?

IIRC, I think I made the suggestion to always save the elf fields
because otherwise it was looking like we were going to need a lot of
spaghetti code.

But if we can find a way to wrap the elf fields in LIVEPATCH while
keeping the code simple, then there's no real downside and I think
that's the way to go.  If somebody else wants to use the fields later,
then they can remove or change the ifdefs as needed.

-- 
Josh
