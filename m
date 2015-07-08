From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 4/8] lsm: smack: smack callbacks for kdbus security hooks
Date: Wed, 08 Jul 2015 16:07:11 -0400
Message-ID: <2412238.IhG4IMMuSs@sifl>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com> <559D28DE.4070406@tycho.nsa.gov> <559D5201.6060400@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559D5201.6060400-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday, July 08, 2015 09:38:25 AM Casey Schaufler wrote:
> On 7/8/2015 6:42 AM, Stephen Smalley wrote:
> > On 07/08/2015 06:25 AM, Paul Osmialowski wrote:

...

> > If Smack only truly needs 3 hooks, then it begs the question of why
> > there are so many other hooks defined.  Are the other hooks just to
> > support finer-grained distinctions, or is Smack's coverage incomplete?
> 
> I haven't been following kdbus closely for a while, but the original
> intent for Smack and kdbus was that it Smack controls would be on the
> objects involved, and that to accomplish that only a small number of
> hooks would be necessary. After all, Smack uses fewer hooks than SELinux
> on other things. I do agree that without a user there is no point in
> having hooks. If SELinux requires the other hooks we might want to
> hold off on asking for the hooks until the SELinux implementation is
> exposed. I also think that AppArmor should be examined as a potential
> user of the hooks, just to make sure the hooks aren't excessively
> oriented toward subject/object based security modules.

In Paul O.'s defense, we did have some discussion about the reasons for these 
hooks, although that seems like ages ago and I would need to dig through the 
archives (my inbox?) to find the reasoning for each.

However, I don't remember being very comfortable with the hooks back them 
largely due to uncertainty about how we were treating kdbus with respect to 
subjects/objects.  I think it's worth restarting that discussion now before we 
nit pick the patches themselves.

-- 
paul moore
security @ redhat
