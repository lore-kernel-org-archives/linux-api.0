From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Thu, 30 Oct 2014 09:09:38 +0100
Message-ID: <5451F242.4070106@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/29/2014 11:33 PM, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman

>> +/**
>> + * kdbus_meta_new() - create new metadata object
>> + * @meta:              New metadata object
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int kdbus_meta_new(struct kdbus_meta **meta)
>> +{
>> +       struct kdbus_meta *m;
>> +
>> +       BUG_ON(*meta);
>> +
>> +       m = kzalloc(sizeof(*m), GFP_KERNEL);
>> +       if (!m)
>> +               return -ENOMEM;
>> +
>> +       /*
>> +        * Remember the PID and user namespaces our credentials belong to;
>> +        * we need to prevent leaking authorization and security-relevant
>> +        * data across different namespaces.
>> +        */
>> +       m->pid_namespace = get_pid_ns(task_active_pid_ns(current));
>> +       m->user_namespace = get_user_ns(current_user_ns());
>> +
> 
> This is unusual, and it could be very expensive (it will serialize
> essentially everyone on an exclusive cacheline).  What attack is it
> protecting against?

As mentioned before, we currently prevent metadata from crossing over
user and pid namespace boundaries. In order to detect such situations,
we need to pin the namespaces of the the task creating such a metadata
object, so we can compare them later, even when the original task is not
alive anymore. But I'm open for cheaper solutions for this, as I'm
admittedly not an expert in these APIs.

>> +static int kdbus_meta_append_cred(struct kdbus_meta *meta)
>> +{
>> +       struct kdbus_creds creds = {
>> +               .uid = from_kuid_munged(current_user_ns(), current_uid()),
>> +               .gid = from_kgid_munged(current_user_ns(), current_gid()),
>> +               .pid = task_pid_vnr(current),
>> +               .tid = task_tgid_vnr(current),
>> +               .starttime = current->start_time,
>> +       };
>> +
>> +       return kdbus_meta_append_data(meta, KDBUS_ITEM_CREDS,
>> +                                     &creds, sizeof(creds));
>> +}
> 
> This seems wrong to me.  Shouldn't this store kuid_t, etc. directly?

The metadata item's memory that is appended here is directly copied into
the final message in the receiver's pool later, so the information has
to be authoritative and translated at this point. This is currently not
a problem as in cases where we cross namespaces, the metadata will not
be added to the final message anyway.

But you're right, if we support translation between namespaces later, we
need to store the kuid_t here, and patch in the the translated version
later, when the message is installed by the receiving peer (which is
when we know which namespace to translate the kuid_t for).

> Also, why pid, tid, and starttime?

Because pid is also part of struct ucred, and starttime seemed to fit in
here as well. After all, an item has some overhead with its header, so
we tried to group information that will most probably be needed
together. Any strong reason not to store it here?


Thanks,
Daniel
