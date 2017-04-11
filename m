From: Kees Cook <keescook@chromium.org>
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/3] LSM: Allow per LSM
 module per "struct task_struct" blob.
Date: Tue, 11 Apr 2017 12:57:58 -0700
Message-ID: <CAGXu5jJAxdtdPuOZVquuajAeR4sbSiFoD4-QUMmcC_RLZy5tfw@mail.gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com> <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
 <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com> <CAEiveUd4Obc+YsCiO7dp3-jypbJ4vMmsBOU=Ax8yF7+6dLes0w@mail.gmail.com>
 <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com> <8551d1ff-2c6e-bf9b-5615-fbff089ef252@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <8551d1ff-2c6e-bf9b-5615-fbff089ef252@schaufler-ca.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 11, 2017 at 12:54 PM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
> On 4/10/2017 9:43 PM, Kees Cook wrote:
>> On Mon, Apr 10, 2017 at 1:00 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>> On Mon, Apr 10, 2017 at 9:26 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> I think that would be the prudent approach. There is still
>>>> the possibility that blob sharing (or full stacking, if you
>>>> prefer) won't be accepted any time soon.
>>> Ok Casey! I will wait for more feedback, and if other maintainers do
>>> not object, I will convert it back to rhashtables in next iterations
>>> making sure that it should be simple to convert later to a blob
>>> sharing mechanism.
>> Would it be possible just to add a single field to task_struct if this
>> LSM is built in? I feel like rhashtables is a huge overhead when a
>> single field is all that's needed.
>
> Special casing the task_struct based on which modules
> are compiled in would work, but I'm under the impression
> that there's a strong desire to keep to one pointer for
> security module information in the major structures.

Right, I meant as far as keeping this patch set unblocked by the other one...

-Kees

-- 
Kees Cook
Pixel Security
