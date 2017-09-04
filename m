From: "Robert O'Callahan" <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Mon, 4 Sep 2017 15:19:13 +1200
Message-ID: <CAOp6jLbpfeypOqJO2B4D0Ye6AK0Ht6uh8GFX++j_kqMLFg21fw@mail.gmail.com>
References: <20170213141452.GA30203@redhat.com> <20170224160354.GA845@redhat.com>
 <87shmv6ufl.fsf@xmission.com> <20170303173326.GA17899@redhat.com>
 <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com>
 <20170402161518.GC12637@redhat.com> <87inmmbjsq.fsf@xmission.com>
Reply-To: robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87inmmbjsq.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Sorry about replying to this old thread, but...

On Mon, Apr 3, 2017 at 9:07 AM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> I don't know who actually useses PTRACE_O_TRACEEXIT so I don't actually
> know what the implications of changing it are.  Let's see...
>
> gdb - no
> upstart - no
> lldb - yes
> strace - no

For the record, rr uses PTRACE_O_TRACEEXIT.

When a thread exits we need to examine its address space to find its
robust futex list and record the changes that will be performed by the
kernel as it cleans up that list. So, any failures to deliver
PTRACE_EVENT_EXIT are potentially problematic for us because we won't
get a chance to examine the address space before it disappears.

Rob
-- 
lbir ye,ea yer.tnietoehr  rdn rdsme,anea lurpr  edna e hnysnenh hhe uresyf toD
selthor  stor  edna  siewaoeodm  or v sstvr  esBa  kbvted,t rdsme,aoreseoouoto
o l euetiuruewFa  kbn e hnystoivateweh uresyf tulsa rehr  rdm  or rnea lurpr
.a war hsrer holsa rodvted,t  nenh hneireseoouot.tniesiewaoeivatewt sstvr  esn
