From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 09:10:28 -0700
Message-ID: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/28/20 3:18 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> now that we have IORING_FEAT_CUR_PERSONALITY...
> 
> How can we optimize the fileserver case now, in order to avoid the
> overhead of always calling 5 syscalls before io_uring_enter()?:
> 
>  /* gain root again */
>  setresuid(-1,0,-1); setresgid(-1,0,-1)
>  /* impersonate the user with groups */
>  setgroups(num, grps); setresgid(-1,gid,-1); setresuid(-1,uid,-1);
>  /* trigger the operation */
>  io_uring_enter();
> 
> I guess some kind of IORING_REGISTER_CREDS[_UPDATE] would be
> good, together with a IOSQE_FIXED_CREDS in order to specify
> credentials per operation.
> 
> Or we make it much more generic and introduce a credsfd_create()
> syscall in order to get an fd for a credential handle, maybe
> together with another syscall to activate the credentials of
> the current thread (or let a write to the fd trigger the activation
> in order to avoid an additional syscall number).
> 
> Having just an fd would allow IORING_REGISTER_CREDS[_UPDATE]
> to be just an array of int values instead of a more complex
> structure to define the credentials.

I'd rather avoid having to add more infrastructure for this, even if
credsfd_create() would be nifty.

With that in mind, something like:

- Application does IORING_REGISTER_CREDS, which returns some index
- Add a IORING_OP_USE_CREDS opcode, which sets the creds associated
  with dependent commands
- Actual request is linked to the IORING_OP_USE_CREDS command, any
  link off IORING_OP_USE_CREDS will use those credentials
- IORING_UNREGISTER_CREDS removes the registered creds

Just throwing that out there, definitely willing to entertain other
methods that make sense for this. Trying to avoid needing to put this
information in the SQE itself, hence the idea to use a chain of links
for it.

The downside is that we'll need to maintain an array of key -> creds,
but that's probably not a big deal.

What do you think? Ideally I'd like to get this done for 5.6 even if we
are a bit late, so you'll have everything you need with that release.

-- 
Jens Axboe
