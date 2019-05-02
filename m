From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the
 running kernel image
Date: Thu, 2 May 2019 14:15:23 -0700
Message-ID: <CACdnJuusGU2DMXaPAjH3+QOcSj-9q6njbxxG-9s2PweDKognvw@mail.gmail.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
 <20190404003249.14356-2-matthewgarrett@google.com> <CACdnJus-+VTy0uOWg982SgZr55Lp7Xot653dJb_tO5T=J6D8nw@mail.gmail.com>
 <alpine.LRH.2.21.1905030653480.32502@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1905030653480.32502@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 2, 2019 at 2:07 PM James Morris <jmorris@namei.org> wrote:
> One possible direction is to (as previously mentioned) assign IDs to each
> callsite and be able to check this ID against a simple policy array
> (allow/deny).  The default policy choices could be reduced to 'all' or
> 'none' during kconfig, and allow a custom policy to be loaded later if
> desired.

Ok. My primary concern around this is that it's very difficult to use
correctly in anything other than the "all" or "none" modes. If a new
kernel feature is added with integrated lockdown support, if an admin
is simply setting the flags of things they wish to block then this
will be left enabled - and may violate the admin's expectations around
integrity. On the other hand, if an admin is simply setting the flags
of things they wish to permit, then adding lockdown support to an
existing kernel feature may result in that feature suddenly being
disabled, which may also violate the admin's expectations around the
flags providing a stable set of behaviour.

Given that, would you prefer such a policy expression to look like?

> Within the policy check hook, we could add a new LSM hook, which would
> allow an LSM to restrictively override the lockdown policy with its own

Ok, that makes sense. If we take this approach, does there need to be
a separate policy mechanism at all? Users who want fine-grained
control would be able to set the behaviour to "None" and then use
their choice of LSM to express more fine-grained control.

> This doesn't really address the completeness / maintenance issue (i.e. "do
> we have everything covered and how do we ensure this on an ongoing
> basis?", and "what will this new lockdown feature break?"), although it
> should make it easier to add new lockdown callsites as they don't have to
> be enabled by the user.

I can start on this.
