From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 09:19:08 -0700
Message-ID: <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
> Am 28.01.20 um 17:10 schrieb Jens Axboe:
>> On 1/28/20 3:18 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>> now that we have IORING_FEAT_CUR_PERSONALITY...
>>>
>>> How can we optimize the fileserver case now, in order to avoid the
>>> overhead of always calling 5 syscalls before io_uring_enter()?:
>>>
>>>  /* gain root again */
>>>  setresuid(-1,0,-1); setresgid(-1,0,-1)
>>>  /* impersonate the user with groups */
>>>  setgroups(num, grps); setresgid(-1,gid,-1); setresuid(-1,uid,-1);
>>>  /* trigger the operation */
>>>  io_uring_enter();
>>>
>>> I guess some kind of IORING_REGISTER_CREDS[_UPDATE] would be
>>> good, together with a IOSQE_FIXED_CREDS in order to specify
>>> credentials per operation.
>>>
>>> Or we make it much more generic and introduce a credsfd_create()
>>> syscall in order to get an fd for a credential handle, maybe
>>> together with another syscall to activate the credentials of
>>> the current thread (or let a write to the fd trigger the activation
>>> in order to avoid an additional syscall number).
>>>
>>> Having just an fd would allow IORING_REGISTER_CREDS[_UPDATE]
>>> to be just an array of int values instead of a more complex
>>> structure to define the credentials.
>>
>> I'd rather avoid having to add more infrastructure for this, even if
>> credsfd_create() would be nifty.
>>
>> With that in mind, something like:
>>
>> - Application does IORING_REGISTER_CREDS, which returns some index
>>
>> - Add a IORING_OP_USE_CREDS opcode, which sets the creds associated
>>   with dependent commands
>> - Actual request is linked to the IORING_OP_USE_CREDS command, any
>>   link off IORING_OP_USE_CREDS will use those credentials
> 
> Using links for this sounds ok.

Great! I'll try and hack this up and see how it turns out.

>> - IORING_UNREGISTER_CREDS removes the registered creds
>>
>> Just throwing that out there, definitely willing to entertain other
>> methods that make sense for this. Trying to avoid needing to put this
>> information in the SQE itself, hence the idea to use a chain of links
>> for it.
>>
>> The downside is that we'll need to maintain an array of key -> creds,
>> but that's probably not a big deal.
>>
>> What do you think?
> 
> So IORING_REGISTER_CREDS would be a simple operation that just takes a
> snapshot of the current_cred() and returns an id that can be passed to
> IORING_OP_USE_CREDS or IORING_UNREGISTER_CREDS?

Right, you would not pass in any arguments, it'd have to be run from the
personality you wish to register. It simply returns an integer, which is
a key to use for IORING_OP_USE_CREDS, or at the end for
IORING_UNREGISTER_CREDS when you no longer wish to use this personality.

>> Ideally I'd like to get this done for 5.6 even if we
>> are a bit late, so you'll have everything you need with that release.
> 
> That would be great!

Crossing fingers...

-- 
Jens Axboe
