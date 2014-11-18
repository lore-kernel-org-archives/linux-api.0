From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
Date: Mon, 17 Nov 2014 16:56:34 -0800
Message-ID: <546A9942.7030102@schaufler-ca.com>
References: <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com> <20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org> <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org> <20141116034005.GC5507@thunk.org> <20141116045232.GB18880@thin> <20141117113734.396798e6@lxorguk.ukuu.org.uk> <CALCETrXi1qHyu4_U7cbROB74n461nBZ9R7=0kfhR8-VFAwOF1w@mail.gmail.com> <0b65fd07-48ea-483b-8fd5-fd84d0bff881@email.android.com> <CALCETrWXC5dMOXTTBOiq4Cv+yjqbA_UdmAN-TDmNAJUo+ABxtg@mail.gmail.com> <20141117223730.GA961@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20141117223730.GA961@cloud>
Sender: linux-security-module-owner@vger.kernel.org
To: josh@joshtriplett.org, Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W.Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, linux-man <linux-man@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, LSM <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/17/2014 2:37 PM, josh@joshtriplett.org wrote:
> On Mon, Nov 17, 2014 at 02:22:59PM -0800, Andy Lutomirski wrote:
>> On Mon, Nov 17, 2014 at 2:11 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
>>>
>>> On November 17, 2014 1:07:30 PM EST, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Nov 17, 2014 3:37 AM, "One Thousand Gnomes"
>>>> <gnomes@lxorguk.ukuu.org.uk> wrote:
>>>>>> optional), I can do that too.  The security model of "having a
>>>> group
>>>>>> gives you less privilege than not having it" seems crazy, but
>>>>>> nonetheless I can see a couple of easy ways that we can avoid
>>>> breaking
>>>>> It's an old pattern of use that makes complete sense in a traditional
>>>>> Unix permission world because it's the only way to do "exclude
>>>> {list}"
>>>>> nicely. Our default IMHO shouldn't break this.
>>>>>
>>>>>> that pattern, no_new_privs being one of them.  I'd like to make
>>>> sure
>>>>>> that nobody sees any other real-world corner case that unprivileged
>>>>>> setgroups would break.
>>>>> Barring the usual risk of people doing improper error checking I
>>>> don't
>>>>> see one immediately.
>>>>>
>>>>> For containers I think it actually makes sense that the sysctl can be
>>>>> applied per container anyway.
>>>> We'll probably need per container sysctls some day.
>>> We already have a mess of per network namespace sysctls,
>>> as well as few for other namespaces.
>>>
>>> We have the infrastructure it is just a matter of using it for whatever purpose we need.
>>>
>> A list of group id ranges that it's permissible to drop would do the
>> trick, both for setgroups and for unshare.  The downside would be that
>> users in those groups (i.e. everyone by default) would not be able to
>> unshare their user ns.
>>
>> Better ideas welcome.
> Personally, I think that seems like more flexibility than necessary to
> achieve the goal.  I think a sysctl turning group-dropping on and off
> would suffice; systems that know they don't use groups to exclude
> specific users can enable that sysctl.

Right. Until someone comes along and installs a package that
uses groups in this particular way. You can't count on the fact
that someone isn't using it in that particular way today as an
indicator that they won't tomorrow. Are you thinking about providing
a tool that will tell sysadmins whether or not their system is safe
to use this option? Certainly you are going to suggest that most
sysadmins would know how to figure out if it is safe to use this
option.

The developers of user namespaces didn't notice it might be a problem.
You can't count on sysadmins or distro developers to do better.

>
> - Josh Triplett
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

