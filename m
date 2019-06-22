From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V34 00/29] Lockdown as an LSM
Date: Fri, 21 Jun 2019 17:03:29 -0700
Message-ID: <20190622000358.19895-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Minor updates over V33 - security_is_locked_down renamed to
security_locked_down, return value of security_locked_down is returned
in most cases, one unnecessary patch was dropped, couple of minor nits
fixed.
