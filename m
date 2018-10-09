From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC v5 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 9 Oct 2018 17:19:11 +0200
Message-ID: <409c22e3-1df8-cf7f-2462-ead2bb3020cf@vivier.eu>
References: <20181009103752.21482-1-laurent@vivier.eu>
 <20181009103752.21482-2-laurent@vivier.eu> <20181009151641.GB10149@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009151641.GB10149@cisco>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <dima@arista.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Biederman <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Le 09/10/2018 à 17:16, Tycho Andersen a écrit :
> On Tue, Oct 09, 2018 at 12:37:52PM +0200, Laurent Vivier wrote:
>> @@ -80,18 +74,32 @@ static int entry_count;
>>   */
>>  #define MAX_REGISTER_LENGTH 1920
>>  
>> +static struct binfmt_namespace *binfmt_ns(struct user_namespace *ns)
>> +{
>> +	struct binfmt_namespace *b_ns;
>> +
>> +	while (ns) {
>> +		b_ns = READ_ONCE(ns->binfmt_ns);
>> +		if (b_ns)
>> +			return b_ns;
>> +		ns = ns->parent;
>> +	}
>> +	WARN_ON_ONCE(1);
> 
> It looks like we warn here,
> 
>> @@ -133,17 +141,18 @@ static int load_misc_binary(struct linux_binprm *bprm)
>>  	struct file *interp_file = NULL;
>>  	int retval;
>>  	int fd_binary = -1;
>> +	struct binfmt_namespace *ns = binfmt_ns(current_user_ns());
>>  
>>  	retval = -ENOEXEC;
>> -	if (!enabled)
>> +	if (!ns->enabled)
> 
> ...but then in cases like this we immediately dereference the pointer
> anyways and crash. Can we return some other error code here in the !ns
> case so we don't crash?

My concern here is I don't want to add code to check an error case that
cannot happen. The first namespace binfmt_ns pointer is initialized with
&init_binfmt_ns, so the return value cannot be NULL.

Thanks,
Laurent
