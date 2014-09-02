From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Date: Tue, 2 Sep 2014 23:07:14 +0400
Message-ID: <54061562.4080306@parallels.com>
References: <5405FBAE.5020303@parallels.com> <20140902184456.GC31793@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140902184456.GC31793@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 09/02/2014 10:44 PM, J. Bruce Fields wrote:
> On Tue, Sep 02, 2014 at 09:17:34PM +0400, Pavel Emelyanov wrote:
>> Hi,
>>
>> There's a problem with getting information about who has a flock on
>> a specific file. The thing is that the "owner" field, that is shown in
>> /proc/locks is the pid of the task who created the flock, not the one
>> who _may_ hold it.
>>
>> If the flock creator shared the file with some other task (by forking
>> or via scm_rights) and then died or closed the file, the information
>> shown in proc no longer corresponds to the reality.
>>
>> This is critical for CRIU project, that tries to dump (and restore)
>> the state of running tasks. For example, let's take two tasks A and B
>> both opened a file "/foo", one of tasks places a LOCK_SH lock on the 
>> file and then "obfuscated" the owner field in /proc/locks. After this
>> we have no ways to find out who is the lock holder.
>>
>> I'd like to note, that for LOCK_EX this problem is not critical -- we
>> may go to both tasks and "ask" them to LOCK_EX the file again (we can
>> do it in CRIU, I can tell more if required). The one who succeeds is 
>> the lock holder.
> 
> It could be both, actually, right?

Two succeeding with LOCK_EX? AFAIU no. Am I missing something?

>> With LOCK_SH this doesn't work. Trying to drop the
>> lock doesn't work either, as flock(LOCK_UN) reports 0 in both cases:
>> if the file is locked and if it is not.
>>
>> That said, I'd like to propose the LOCK_TEST flag to the flock call,
>> that would check whether the lock of the given type (LOCK_SH or LOCK_EX)
>> exists on the file we test. It's not the same as the existing in-kernel
>> FL_ACCESS flag, which checks whether the new lock is possible, but
>> it's a new FL_TEST flag, that checks whether the existing lock is there.
>>
>> What do you think?
> 
> I guess I can't see anything really wrong with it.
> 
> It ignores the (poorly documented) LOCK_MAND case, but maybe that's OK.

I actually checked it and it seemed to work. What problems do
you see with this case?

> Would it make sense to return the lock type held instead, so you could
> do one flock(fd, LOCK_TEST) instead of flock(fd, LOCK_TEST|LOCK_SH) and
> flock(fd, LOCK_TEST|LOCK_EX) ?

Well, in our case we parse /proc/locks anyway to see what
files at least to test for being locked. But what you propose
looks even better. I'll look what can be done here.

> It'd be nice if we could fix /proc/locks.  (You'd think I'd know better,
> but I've certainly been confused before when /proc/locks told me a lock
> was owned by a nonexistant PID.)  But as long as multiple PIDs can "own"
> a flock and as long as there's no simple ID we can use to refer to a
> given struct file, I don't see an easy solution.
> 
> --b.
> 
> 
>>
>> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
>>
>> ---
>>
>> diff --git a/fs/locks.c b/fs/locks.c
>> index bb08857..50842bf 100644
>> --- a/fs/locks.c
>> +++ b/fs/locks.c
>> @@ -830,7 +830,7 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
>>  	int found = 0;
>>  	LIST_HEAD(dispose);
>>  
>> -	if (!(request->fl_flags & FL_ACCESS) && (request->fl_type != F_UNLCK)) {
>> +	if (!(request->fl_flags & (FL_ACCESS|FL_TEST)) && (request->fl_type != F_UNLCK)) {
>>  		new_fl = locks_alloc_lock();
>>  		if (!new_fl)
>>  			return -ENOMEM;
>> @@ -850,11 +850,18 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
>>  			continue;
>>  		if (request->fl_type == fl->fl_type)
>>  			goto out;
>> +		if (request->fl_flags & FL_TEST)
>> +			break;
>>  		found = 1;
>>  		locks_delete_lock(before, &dispose);
>>  		break;
>>  	}
>>  
>> +	if (request->fl_flags & FL_TEST) {
>> +		error = -ENOENT;
>> +		goto out;
>> +	}
>> +
>>  	if (request->fl_type == F_UNLCK) {
>>  		if ((request->fl_flags & FL_EXISTS) && !found)
>>  			error = -ENOENT;
>> @@ -1852,15 +1859,16 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
>>  {
>>  	struct fd f = fdget(fd);
>>  	struct file_lock *lock;
>> -	int can_sleep, unlock;
>> +	int can_sleep, unlock, test;
>>  	int error;
>>  
>>  	error = -EBADF;
>>  	if (!f.file)
>>  		goto out;
>>  
>> +	test = (cmd & LOCK_TEST);
>>  	can_sleep = !(cmd & LOCK_NB);
>> -	cmd &= ~LOCK_NB;
>> +	cmd &= ~(LOCK_NB|LOCK_TEST);
>>  	unlock = (cmd == LOCK_UN);
>>  
>>  	if (!unlock && !(cmd & LOCK_MAND) &&
>> @@ -1872,6 +1880,8 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
>>  		goto out_putf;
>>  	if (can_sleep)
>>  		lock->fl_flags |= FL_SLEEP;
>> +	if (test)
>> +		lock->fl_flags |= FL_TEST;
>>  
>>  	error = security_file_lock(f.file, lock->fl_type);
>>  	if (error)
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 9418772..9230e1d 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -844,6 +844,7 @@ static inline struct file *get_file(struct file *f)
>>  #define FL_DOWNGRADE_PENDING	256 /* Lease is being downgraded */
>>  #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
>>  #define FL_OFDLCK	1024	/* lock is "owned" by struct file */
>> +#define FL_TEST		2048
>>  
>>  /*
>>   * Special return value from posix_lock_file() and vfs_lock_file() for
>> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
>> index 7543b3e..7302e36 100644
>> --- a/include/uapi/asm-generic/fcntl.h
>> +++ b/include/uapi/asm-generic/fcntl.h
>> @@ -184,6 +184,7 @@ struct f_owner_ex {
>>  #define LOCK_READ	64	/* which allows concurrent read operations */
>>  #define LOCK_WRITE	128	/* which allows concurrent write operations */
>>  #define LOCK_RW		192	/* which allows concurrent read & write ops */
>> +#define LOCK_TEST	256	/* check for my SH|EX locks present */
>>  
>>  #define F_LINUX_SPECIFIC_BASE	1024
>>  
>>
> .
> 

