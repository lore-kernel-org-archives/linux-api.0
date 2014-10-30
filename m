From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add connection, queue handling and message validation code
Date: Wed, 29 Oct 2014 20:55:58 -0700
Message-ID: <CALCETrXm116+eRvYY7QNbHcrOpZYOCqvC_WPguPZm-G+UEHeGw@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-6-git-send-email-gregkh@linuxfoundation.org> <87k33iw759.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87k33iw759.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 8:47 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:
>
>> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>>
>> This patch adds code to create and destroy connections, to validate
>> incoming messages and to maintain the queue of messages that are
>> associated with a connection.
>>
>> Note that connection and queue have a 1:1 relation, the code is only
>> split in two parts for cleaner separation and better readability.
>
> You are not performing capability checks at open time.
>
> As such this API is suceptible to a host of file descriptor passing attacks.

To be fair, write(2) doesn't work on these fds, so the usual attacks
don't work.  But who knows what absurd things kdbus clients will do
with fd passing?

--Andy

>
>> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>> ---
>
>> +/*
>> + * Check for maximum number of messages per individual user. This
>> + * should prevent a single user from being able to fill the receiver's
>> + * queue.
>> + */
>> +static int kdbus_conn_queue_user_quota(struct kdbus_conn *conn,
>> +                                    const struct kdbus_conn *conn_src,
>> +                                    struct kdbus_queue_entry *entry)
>> +{
>> +     unsigned int user;
>> +
>> +     if (!conn_src)
>> +             return 0;
>> +
>> +     if (ns_capable(&init_user_ns, CAP_IPC_OWNER))
>> +             return 0;
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
