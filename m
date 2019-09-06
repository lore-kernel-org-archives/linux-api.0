From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Fri, 06 Sep 2019 12:48:59 -0400
Message-ID: <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
References: <20190906152455.22757-1-mic@digikod.net>
         <20190906152455.22757-2-mic@digikod.net>
         <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
         <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Florian Weimer <fweimer@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean Christopherson <sean.j.christopherson@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, 2019-09-06 at 18:06 +0200, Mickaël Salaün wrote:
> On 06/09/2019 17:56, Florian Weimer wrote:
> > Let's assume I want to add support for this to the glibc dynamic loader,
> > while still being able to run on older kernels.
> > 
> > Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> > with EINVAL, try again without O_MAYEXEC?
> 
> The kernel ignore unknown open(2) flags, so yes, it is safe even for
> older kernel to use O_MAYEXEC.
> 

Well...maybe. What about existing programs that are sending down bogus
open flags? Once you turn this on, they may break...or provide a way to
circumvent the protections this gives.

Maybe this should be a new flag that is only usable in the new openat2()
syscall that's still under discussion? That syscall will enforce that
all flags are recognized. You presumably wouldn't need the sysctl if you
went that route too.

Anyone that wants to use this will have to recompile anyway. If the
kernel doesn't support openat2 or if the flag is rejected then you know
that you have no O_MAYEXEC support and can decide what to do.

> > Or do I risk disabling this security feature if I do that?
> 
> It is only a security feature if the kernel support it, otherwise it is
> a no-op.
> 

With a security feature, I think we really want userland to aware of
whether it works.

> > Do we need a different way for recognizing kernel support.  (Note that
> > we cannot probe paths in /proc for various reasons.)
> 
> There is no need to probe for kernel support.
> 
> > Thanks,
> > Florian
> > 
> 
> --
> Mickaël Salaün
> 
> Les données à caractère personnel recueillies et traitées dans le cadre de cet échange, le sont à seule fin d’exécution d’une relation professionnelle et s’opèrent dans cette seule finalité et pour la durée nécessaire à cette relation. Si vous souhaitez faire usage de vos droits de consultation, de rectification et de suppression de vos données, veuillez contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez reçu ce message par erreur, nous vous remercions d’en informer l’expéditeur et de détruire le message. The personal data collected and processed during this exchange aims solely at completing a business relationship and is limited to the necessary duration of that relationship. If you wish to use your rights of consultation, rectification and deletion of your da
 ta, please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message in error, we thank you for informing the sender and destroying the message.

-- 
Jeff Layton <jlayton@kernel.org>
