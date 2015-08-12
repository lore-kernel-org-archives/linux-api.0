From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with sysfs_create_empty_dir
Date: Wed, 12 Aug 2015 15:27:26 -0500
Message-ID: <87r3n82qxd.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<878ucrhxi9.fsf@x220.int.ebiederm.org>
	<20150811184426.GH23408@mtj.duckdns.org>
	<877fp1hcuj.fsf@x220.int.ebiederm.org>
	<CALCETrXE=fKa3XkEEo6y2=ZNtsuBfX=kaoyDwiP0C2BwqKJWjw@mail.gmail.com>
	<87mvxxcogp.fsf@x220.int.ebiederm.org>
	<20150812200035.GB4496@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150812200035.GB4496@mtj.duckdns.org> (Tejun Heo's message of
	"Wed, 12 Aug 2015 16:00:35 -0400")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On Tue, Aug 11, 2015 at 07:58:14PM -0500, Eric W. Biederman wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>> 
>> > On Tue, Aug 11, 2015 at 11:57 AM, Eric W. Biederman
>> > <ebiederm@xmission.com> wrote:
>> >>
>> >> *Boggle*
>> >>
>> >> The only time this should prevent anything is when in a container when
>> >> you are not global root.  And then only mounting sysfs should be
>> >> affected.
>> >
>> > Before:
>> >
>> > open("/sys/kernel/debug/asdf", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK,
>> > 0666) = -1 EACCES (Permission denied)
>> >
>> >
>> > After:
>> >
>> > open("/sys/kernel/debug/asdf", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK,
>> > 0666) = -1 ENOENT (No such file or directory)
>> >
>> > Something broke.  I don't know whether CentOS cares about that change,
>> > but there could be other odd side effects.
>> 
>> Thanks for pointing this out.  I don't know if broke is quite the right
>> word for a change in error codes on lookup failure, but I agree it is a
>> difference that could have affected something.
>> 
>> The behavior of empty proc dirs actually return -ENOENT in this
>> situation and so it is a little fuzzy about which is the best behavior
>> to use.
>> 
>> Creativing a negative dentry and and then letting vfs_create fail may be
>> the better way to go.
>> 
>> Negative dentries are weird enough that I would prefer not to have code
>> that creates negative dentries.  They could easily be a lurking trap
>> for some filesystems dentry operations.
>> 
>> The patch below is enough to change the error code if someone who can
>> reproduce this wants to try this.
>> 
>> Eric
>> 
>> diff --gdiff --git a/fs/libfs.c b/fs/libfs.c
>> index 102edfd39000..3a452a485cbf 100644
>> --- a/fs/libfs.c
>> +++ b/fs/libfs.c
>> @@ -1109,7 +1109,7 @@ EXPORT_SYMBOL(simple_symlink_inode_operations);
>>   */
>>  static struct dentry *empty_dir_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
>>  {
>> -       return ERR_PTR(-ENOENT);
>> +       return NULL;
>
> And let's please restore this too.  Sentiments about negative dentries
> aside, It's outright wrong to report -ENOENT on creat.

proc has always reported -ENOENT. sysfs is the odd one out.

I am not completely certain that trivial patch above, does not introduce
a leak, a NULL pointer dereference or something else nasty when the code
is hit.

So far it seems that no one cares.  And since the change is brittle I am
not inclined to mess with it this week, as I have other demands on my
limited review bandwidth right now.

Eric
