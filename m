From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Fri, 6 Sep 2019 14:27:19 -0700
Message-ID: <CALCETrVR5d2XTpAN8QLRv3cYDfpAdZRNNcD-TtE5H+v7-i7QhQ@mail.gmail.com>
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com> <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
 <D2A57C7B-B0FD-424E-9F81-B858FFF21FF0@amacapital.net> <8dc59d585a133e96f9adaf0a148334e7f19058b9.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-16867-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <8dc59d585a133e96f9adaf0a148334e7f19058b9.camel@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, Florian Weimer <fweimer@redhat.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sea
List-Id: linux-api@vger.kernel.org

> On Sep 6, 2019, at 1:51 PM, Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2019-09-06 at 13:06 -0700, Andy Lutomirski wrote:
>
>> I=E2=80=99m not at all convinced that the kernel needs to distinguish al=
l these, but at least upgradability should be its own thing IMO.
>
> Good point. Upgradability is definitely orthogonal, though the idea
> there is to alter the default behavior. If the default is NOEXEC then
> UPGRADE_EXEC would make sense.
>
> In any case, I was mostly thinking about the middle two in your list
> above. After more careful reading of the patches, I now get get that
> Micka=C3=ABl is more interested in the first, and that's really a differe=
nt
> sort of use-case.
>
> Most opens never result in the fd being fed to fexecve or mmapped with
> PROT_EXEC, so having userland explicitly opt-in to allowing that during
> the open sounds like a reasonable thing to do.
>
> But I get that preventing execution via script interpreters of files
> that are not executable might be something nice to have.
>
> Perhaps we need two flags for openat2?
>
> OA2_MAYEXEC : test that permissions allow execution and that the file
> doesn't reside on a noexec mount before allowing the open
>
> OA2_EXECABLE : only allow fexecve or mmapping with PROT_EXEC if the fd
> was opened with this
>
>
>

We could go one step farther and have three masks: check_perms,
fd_perms, and upgrade_perms.  check_perms says =E2=80=9Cfail if I don=E2=80=
=99t have
these perms=E2=80=9D.  fd_perms is the permissions on the returned fd, and
upgrade_perms is the upgrade mask.  (fd_perms  & ~check_perms) !=3D 0 is
an error.  This makes it possible to say "I want to make sure the file
is writable, but I don't actually want to write to it", which could
plausibly be useful.

I would argue that these things should have new, sane bits, e.g.
FILE_READ, FILE_WRITE, and FILE_EXECUTE (or maybe FILE_MAP_EXEC and
FILE_EXECVE).  And maybe there should be at least 16 bits for each
mask reserved.  Windows has a lot more mode bits than Linux, and it's
not entirely nuts.  We do *not* need any direct equivalent of O_RDWR
for openat2().

--Andy
