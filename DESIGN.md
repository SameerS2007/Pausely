# PAUSELY

A gaming accountability system -- don't play too much

## Overview

This app is meant to hold you to your goals. We don't believe playing games is bad --- but its easy to play a good game for hours and hours on end, when you were meant to be doing work or something else. The goal of this app is to make sure people don't play when they shouldn't and only play for the time they intend to.

## Problem Statement

Playing games is good, but its easy to spiral. How can we allow people to still enjoy games but not play too much or at the wrong times?

## Goals 
- Force users to be unable play during certain times of the day
- Make sure users only play as much as they intend to play
- Allow users to finish their match or save their game (so don't be too forceful)
- Use an Alarmy style system to be annoying until the user shows that they have closed the game

## Non-Goals

- Completely stop users from playing games
- Force users to lose in-game progress or ranks
- Rigidly stop users from doing things like play with their friends

## User Experience

The user needs to hold them selves accountable, so overrides are available, but need to confirm that it is intentional, so make users take a second before they override.

Once a session is started the user should be forced to stop it after their time is over, but not rigidly. For example A bothering reminder every 5 minutes to save it which will keep people accountable.
 
## System Architecture

Pausely is composed of three main components: 
1. iOS Application
	- The core app
2. Windows Companion Agent 
	- This keeps track of steam or whatever game launcher -- so you can't just open steam
3. Computer Vision Module
	- This is how the app confirms you closed the game. While technically you could use the windows agent this makes you feel more accountable about closing it

## Technology Choices

Technology: Python Libraries: - psutil - FastAPI/WebSockets Reason: - Strong ecosystem for system monitoring - Familiar language - Easy integration with machine learning tools 
### Computer Vision 
Technology: PyTorch + OpenCV 

Reason: 
- Learn image classification 
- Build and deploy a custom computer vision model
- Leverage existing ML knowledge 

### Data Storage 
Technology: SQLite 

Reason: 
- Lightweight local database 
- No cloud infrastructure required 
- Appropriate for a personal application

## Data Model

Pausely stores information about gaming sessions and violations. 
### Session 
Stores information about each gaming session. 

Fields: 
- id
- game_name 
- session_type 
- start_time 
- end_time 
- duration 
- status 
- verified 
### Violation 
Stores unauthorized gaming attempts.
 
Fields: 
- id 
- timestamp 
- detected_game 
- resolved 
- resolution_time 

### User Settings 
Stores personal preferences. 

Fields: 
- allowed_hours 
- default_session_length 
- notification_settings

## Implementation Plan
The project will be developed in phases. 
### Phase 1: 
Foundation Goals: 
- Create repository structure 
- Build initial iOS app 
- Build Windows companion skeleton 

### Phase 2: 
Session Management Goals: 
- Create gaming sessions 
- Track active sessions 
- Connect iOS app and Windows agent 

### Phase 3: 
Unauthorized Gaming Detection Goals: 
- Detect Steam game launches 
- Trigger violation mode 
- Send notifications to iOS app 

### Phase 4: 
Session Completion Verification Goals: 
- Capture screenshots/images 
- Train computer vision model 
- Verify gaming has stopped 

### Phase 5: 
Polish and Release Goals: 
- Improve user experience 
- Write documentation 
- Publish open-source repository

## Future Improvements
Potential future improvements: 
- Automatic Steam library detection 
- Improved game recognition
-  Cloud synchronization
-  Cross-platform support 
- Friend/social accountability features 
- More advanced computer vision models 
- Mobile widgets 
- Gaming statistics and insights 
- App Store release

## Open Questions
Questions to resolve during development: 
- Should unauthorized games be closed automatically or only trigger alerts? 
- How should the phone and Windows agent authenticate each other? 
- Should social gaming sessions have different limits? 
- How accurate does the computer vision model need to be? 
- Should session completion require proof every time? 
- How should offline usage work? 
- How should multiple computers be supported?
