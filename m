From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 2/4] namei: O_BENEATH-style path resolution flags
Date: Fri, 23 Nov 2018 08:07:03 -0800
Message-ID: <CALCETrURCXjNMBR6DjujVc6HHHS=CbET81kHS+odur+Bm-z7Tg@mail.gmail.com>
References: <20181112142654.341-1-cyphar@cyphar.com> <20181112142654.341-3-cyphar@cyphar.com>
 <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: j@bitron.ch
Cc: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Linux API <linux-api@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, Aleksa Sarai <asarai@suse.de>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> On Nov 23, 2018, at 5:10 AM, J=C3=BCrg Billeter <j@bitron.ch> wrote:
>
> Hi Aleksa,
>
>> On Tue, 2018-11-13 at 01:26 +1100, Aleksa Sarai wrote:
>> * O_BENEATH: Disallow "escapes" from the starting point of the
>>  filesystem tree during resolution (you must stay "beneath" the
>>  starting point at all times). Currently this is done by disallowing
>>  ".." and absolute paths (either in the given path or found during
>>  symlink resolution) entirely, as well as all "magic link" jumping.
>
> With open_tree(2) and OPEN_TREE_CLONE, will O_BENEATH still be
> necessary?

This discussion reminds me of something I=E2=80=99m uncomfortable with in t=
he
current patches: currently, most of the O_ flags determine some
property of the returned opened file.  The new O_ flags you're adding
don't -- instead, they affect the lookup of the file.  So O_BENEATH
doesn't return a descriptor that can only be used to loop up files
beneath it -- it just controls whether open(2) succeeds or fails.  It
might be nice for the naming of the flags to reflect this.  I also
don't love that we have some magic AT_ flags that work with some
syscalls and some magic O_ flags that work with others.

In this regard, I liked the AT_ naming better.  Although I don't love
adding AT_ flags because the restrict our ability to usefully use the
high bits of the fd in the future.

--Andy
