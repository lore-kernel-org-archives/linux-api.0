From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 7/7] random: Remove kernel.random.read_wakeup_threshold
Date: Wed, 25 Sep 2019 20:09:26 -0500
Message-ID: <87sgoj2795.fsf@x220.int.ebiederm.org>
References: <cover.1568990048.git.luto@kernel.org>
        <66b16acf2953fc033abc9641b9cf43d23e75a8e9.1568990048.git.luto@kernel.org>
        <CAG48ez2tnJzLNCgAqCC+AOKuLGBSvBRi2_HZ97bEJ0zP1kWLHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2tnJzLNCgAqCC+AOKuLGBSvBRi2_HZ97bEJ0zP1kWLHg@mail.gmail.com>
        (Jann Horn's message of "Tue, 24 Sep 2019 22:30:55 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Theodore Tso <tytso@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Fri, Sep 20, 2019 at 4:37 PM Andy Lutomirski <luto@kernel.org> wrote:
>> It has no effect any more, so remove it.  We can revert this if
>> there is some user code that expects to be able to set this sysctl.
>>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>  drivers/char/random.c | 18 +-----------------
>>  1 file changed, 1 insertion(+), 17 deletions(-)
>>
>> diff --git a/drivers/char/random.c b/drivers/char/random.c
> [...]
>> -       {
>> -               .procname       = "read_wakeup_threshold",
>
> There's a line in bin_random_table in kernel/sysctl_binary.c that
> refers to this sysctl, that should probably also be deleted?

I think it should be safe to leave in kernel/sysctl_binary.c

This reminds me.  I think we may finally be at a point where we can
remove practically all of kernel/sysctl_binary.c

I need to double check but last I looked no distro enables
COINFIG_SYSCTL_SYSCALL anymore.  Ubunutu was the last distro I know of
that enabled it, and I think it has been a year or more since Ubuntu
disabled CONFIG_SYSCTL_SYSCALL.

Eric
